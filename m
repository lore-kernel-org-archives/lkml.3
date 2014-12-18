Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaLRWfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:35:22 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:56782 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRWfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:35:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: dwalker@fifo99.com,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] arch: arm: mach-msm: smd.c: Remove some unused functions
Date: Thu, 18 Dec 2014 23:35:04 +0100
Message-ID: <6909946.FWqDZQSxq2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141218220128.GA10615@fifo99.com>
References: <1417914740-8390-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <CAFo99gbPKw4uHY_QqyZ495O9QLKL69HQyJmQUKNaGQTNqsG-mw@mail.gmail.com> <20141218220128.GA10615@fifo99.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:LV5eOh+eRYmCP8iRCnjMMYy3fzxQ7PZ5SOj0GaQJ78WUYWHHCo9
 WuJsqRw8EWb2ZuGhv8jk5gdrJj3Yz2DqDuhHBIn6URSPWG45hupsGDCRKyRLRUwkWmyqOLu
 D7XrkABdtXPH7x5Eg/1bpgLg2oT4UjW79fICLSGotSRIljAgw7E3l2+2U+cevDzlrYNq3VZ
 JYZeEGoUDargXR6x32rHw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2014 22:01:28 dwalker@fifo99.com wrote:
> On Tue, Dec 16, 2014 at 12:20:43AM +0100, Rickard Strandqvist wrote:
> > Hi
> > 
> > My script looks for the same function name, so if they then would be
> > named exactly the same, they would come up.
> > 
> > But I can not even find drivers/staging/dream/   or is this really new code?
> 
> Maybe it was deleted already ..

It's been gone for over four years, after nobody worked on cleaning it up
for a while before that:

commit 3414df8ca38b203c8a5ad8efc32d4a3836a0596d
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Fri Oct 29 12:42:18 2010 -0700

    Staging: dream: remove dream driver and arch from tree
    
    This code is stalled, with no one working on it anymore, and the main
    msm code is now going through the proper channels to get merged
    correctly.
    
    So remove it as it contains a number of kernel information leaks and it
    is doubtful if it even still builds anymore.
    
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Acked-by: Bryan Huntsman <bryanh@codeaurora.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


	Arnd
