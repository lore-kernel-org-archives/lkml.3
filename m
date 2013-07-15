Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab3GOWKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:10:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:53068 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab3GOWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:10:19 -0400
Message-ID: <51E47339.10500@windriver.com>
Date: Mon, 15 Jul 2013 18:10:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Randy Dunlap <rdunlap@infradead.org>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: update git pull info in SubmittingPatches
References: <1373923096-25674-1-git-send-email-paul.gortmaker@windriver.com> <51E46A4D.6060108@infradead.org> <51E46C3B.5020104@windriver.com> <51E46E55.7090909@infradead.org> <51E47051.7030608@zytor.com>
In-Reply-To: <51E47051.7030608@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-07-15 05:57 PM, H. Peter Anvin wrote:
> Something else to put in there: if someone absolutely feels the need to
> put cover text before the patch, it should be separated from the patch
> proper by a scissor line (---8<---) or there is no support for
> automating the patch.

Sounds reasonable; I'll add it to my mental to-do list for sections
to update in this file.
