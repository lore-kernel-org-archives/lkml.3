Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaKMIvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:51:05 -0500
Received: from mout.web.de ([212.227.15.4]:58524 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaKMIvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:51:03 -0500
Message-ID: <546470D8.9050603@users.sourceforge.net>
Date: Thu, 13 Nov 2014 09:50:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 2/2] staging: rtl8188eu: Better memory clean-up in
 efuse_phymap_to_logical()
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <544954FD.8040607@users.sourceforge.net> <20141029084702.GA18675@kroah.com> <5453CD0D.9010206@users.sourceforge.net> <alpine.DEB.2.10.1410311900201.2481@hadrien> <5463C10D.6020409@users.sourceforge.net> <5463C373.5050804@users.sourceforge.net> <20141112211438.GI6749@mwanda> <5463D62D.3010206@users.sourceforge.net> <20141112220540.GK5351@mwanda>
In-Reply-To: <20141112220540.GK5351@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3VpKZ3t/S0kKAiGKDmD/XFjACXqUvUilcdT/eGChJeOgjVW4L/z
 6Kkp/iRLnFx1iYS9RxVnRbC41ePqbXrl1X9IbFgiMb9/pv0Z6Yo2VU5aRDJAfgqYGN3/aol
 w0DMFnxZYHrky3lIgiuxTW7Pxu+I/4lX116Oy5a8QEDfIMgaIOgOHbNefMfsygCzx3QVoYA
 0RovJ966Heeug7b9TJBDQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> +		goto cleanup1;
>>>
>>> 1) Don't use GW-BASIC label names.  Label names should reflect what the
>>> label does such as free_fuse_word or free_fuse_tabel.
>>>
>>> 2) Don't use do-nothing labels.  Just return directly.
>>
>> Does the document "CodingStyle" need any extensions for special cases?
> 
> I don't understand.

Should the naming convention become more explicit for jump labels?


> CodingStyle says:
> 
> "If there is no cleanup needed then just return directly."

Do you want that I send another update suggestion with other corrections
for jump labels in the affected function implementation?

Regards,
Markus

