Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaG3CeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:34:19 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65424 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaG3CeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 22:34:18 -0400
Message-ID: <53D859A3.1010607@gmail.com>
Date: Wed, 30 Jul 2014 08:04:11 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Tobias Klauser <tklauser@distanz.ch>
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        silvio.fricke@gmail.com, linux-kernel@vger.kernel.org, bjorn@mork.no
Subject: Re: [PATCH 1/1] drivers: staging: vt6655: ioctl.c - missing __user
 annotation
References: <1406534292-22601-1-git-send-email-askb23@gmail.com> <20140729080538.GA16199@distanz.ch> <20140729091751.GB4856@mwanda>
In-Reply-To: <20140729091751.GB4856@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 29 July 2014 02:47 PM, Dan Carpenter wrote:
> On Tue, Jul 29, 2014 at 10:05:38AM +0200, Tobias Klauser wrote:
>
>> Wouldn't it be better to annotate the data member in struct tagSCmdRequest
>> with __user instead of introducing all these casts?

Hi,

Yes, having the data member annotated as '__user' in 'struct
tagSCmdRequest' looks like a much cleaner way for fixing these warnings.
I will re-work on this patch this patch and submit again.

Thanks,
Anil
