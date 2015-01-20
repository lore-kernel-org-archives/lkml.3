Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbbATSGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:06:52 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:62855 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbATSFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <20150121045258.GA19087@Arch-Thinkpad>
References: <20150121045258.GA19087@Arch-Thinkpad>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 20 Jan 2015 18:05:03 +0000
Message-ID: <CA+V-a8vNv1DYL+rcGTxSXwNoWvZ4wfJqdp4zWMzsFTVYF2iBsg@mail.gmail.com>
Subject: Re: [PATCH] staging: fix davinci_vpfe: fix space prohibted before
 that ','
To: Ahmad Hassan <ahmad.hassan612@gmail.com>
Cc: OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 21, 2015 at 4:52 AM, Ahmad Hassan <ahmad.hassan612@gmail.com> wrote:
> This patch fixes the following checkpatch.pl error:
> fix space prohibited before that ',' at line 904

Thanks for the patch, but there already exists a patch [1] fixing this.

[1] https://patchwork.linuxtv.org/patch/27912/

Thanks,
--Prabhakar Lad
