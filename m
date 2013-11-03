Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3KCRrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 12:47:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36633 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3KCRrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 12:47:35 -0500
Message-ID: <52768B8E.1060902@zytor.com>
Date: Sun, 03 Nov 2013 09:44:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andreas Werner <wernerandy@gmx.de>, tglx@linutronix.de
CC: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        bp@alien8.de
Subject: Re: [PATCH v2] X86: MM: Add PAT Type write-through in combination
 with mtrr
References: <1383480142-5665-1-git-send-email-wernerandy@gmx.de>
In-Reply-To: <1383480142-5665-1-git-send-email-wernerandy@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 04:02 AM, Andreas Werner wrote:
> 
> Since marking IO Memory as cachable is not valid, WT is the
> best way for caching/bursting on MMIO Devices.
> 

Uh... WT *is* cachable...

	-hpa


