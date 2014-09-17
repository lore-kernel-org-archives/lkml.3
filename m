Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaIQGyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 02:54:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35707 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaIQGyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 02:54:20 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-34-5419301ac272
Message-id: <54193018.50808@samsung.com>
Date: Wed, 17 Sep 2014 08:54:16 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Felipe Balbi <balbi@ti.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb-gadget tree with the vfs tree
References: <20140917161658.2e4eb3f1@canb.auug.org.au>
In-reply-to: <20140917161658.2e4eb3f1@canb.auug.org.au>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xK7pSBpIhBk0TOC0O3q+3uLxrDpvF
	wYVtjBZb915ltzj/9zirA6tH440bbB7Hb2xn8vi8Sc5j05O3TAEsUVw2Kak5mWWpRfp2CVwZ
	jRNamQomsFScfPGctYFxBXMXIyeHhICJxJkdp5ggbDGJC/fWs3UxcnEICSxllHjyYxMrhPOR
	UWLOh2dgVbwCGhLXTp9iBbFZBFQlvl2fBTaJTUBHYsv3CYwgtqhAmMSzXweh6gUlfky+xwJi
	iwjkSkxfvg2sl1nARmL26gXsILawgJ9E275NYLaQgJnEt7fvwOZwCphL9LRcBKrnAKrXk7h/
	UQuiVV5i85q3zBMYBWYh2TALoWoWkqoFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJC
	+MsOxsXHrA4xCnAwKvHwbrgsESLEmlhWXJl7iFGCg1lJhHeWnmSIEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsYa+z25jBeyP2suP69lXL2XzUD5frqDwVMGudjuprheLo1N/t8m5WsaxfV/fWRo
	8/M0m3eM+q3EHIELstcNcrdvU+F880pF9/LabT2cGUsb31Uw3fwnsFSXX8E5er3pSu33VsLL
	rnhOy+QWkV+77qy9mnjQeUcv56+Rj5hkmeXbdoqbi894rMRSnJFoqMVcVJwIACCGN6Y/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 08:16 AM, Stephen Rothwell wrote:
> Hi Felipe,
> 
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/gadget/function/f_fs.c between commit 8322215aa91c ("f_fs:
> saner API for ffs_sb_create_file()") from the vfs tree and commit
> 1b0bf88fd8b8 ("usb: gadget: f_fs: virtual endpoint address mapping")
> from the usb-gadget tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Looks good for me.

Thanks
Robert Baldyga
