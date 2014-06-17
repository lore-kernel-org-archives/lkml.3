Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004AbaFQQTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:19:25 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:55711 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933524AbaFQQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:19:21 -0400
Message-ID: <1403021958.1984.31.camel@x220>
Subject: Re: Build regressions/improvements in v3.16-rc1
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 18:19:18 +0200
In-Reply-To: <1403018163-25307-1-git-send-email-geert@linux-m68k.org>
References: <1403018163-25307-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2014 16:19:19.0890 (UTC) FILETIME=[E48EAB20:01CF8A47]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 17:16 +0200, Geert Uytterhoeven wrote:
>   + /scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'adv_scsiqp' may be used uninitialized in this function [-Wuninitialized]:  => 8826:2
>   + /scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'next_qp' may be used uninitialized in this function [-Wuninitialized]:  => 8544:3

Nothing changed in advansys.c itself. New compiler or changes to the
kernel's build system?

>   + /scratch/kisskb/src/drivers/scsi/aic94xx/aic94xx_sds.c: warning: 'offs' may be used uninitialized in this function [-Wuninitialized]: 597:21 => 273:25, 597:21

This warning is over two years old, at least.

>   + /scratch/kisskb/src/drivers/usb/misc/usb3503.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 195:11

See https://lkml.org/lkml/2014/6/2/511 .


Paul Bolle

