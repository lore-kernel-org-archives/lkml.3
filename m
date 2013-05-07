Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3EGQBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:01:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57149 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758269Ab3EGQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:01:06 -0400
Message-ID: <5189252C.20201@zytor.com>
Date: Tue, 07 May 2013 09:00:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, boot: Cleanup A20 Code
References: <1367942305-32748-1-git-send-email-syed.salman.mansoor@gmail.com>
In-Reply-To: <1367942305-32748-1-git-send-email-syed.salman.mansoor@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 08:58 AM, Syed Salman Mansoor wrote:
> Fix checkpatch.pl warnings in a20.c
> i)  WARNING: please, no spaces at the start of a line
> ii) WARNING: suspect code indent for conditional statements
> iii) ERROR: trailing whitespace

This patch doesn't actually change anything meaningful.  Sorry,
"whitespace massaging" patches are generally considered pure nuisance.

	-hpa

