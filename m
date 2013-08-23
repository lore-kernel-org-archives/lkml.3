Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3HWTck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:32:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51216 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794Ab3HWTcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:32:36 -0400
Message-ID: <1377279064.4147.51.camel@dabdike>
Subject: Re: [PATCH 1/3] arcmsr: Modify maxium outstanding command
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?UTF-8?Q?=E9=BB=83=E6=B8=85=E9=9A=86?= <ching2048@areca.com.tw>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, ching2048@gmai.com
In-Reply-To: <1068BE1DEB04498495FD7913A7B2CA53@chingDT>
References: <1068BE1DEB04498495FD7913A7B2CA53@chingDT>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Aug 2013 13:31:04 -0400
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 10:52 +0800, 黃清隆 wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Modify maximum outstanding command number, notify command complete with auto 
> request sense, reassign ARC12x4 series to SATA type adapter
> Signed-off-by: Chingching2048@areca.com.tw

That should be

Signed-off-by: Ching <ching2048@areca.com.tw>

Shouldn't it?

Also, this patch doesn't apply; it doesn't look to be constructed
against an upstream version of the driver:
patching file drivers/scsi/arcmsr/arcmsr.h
Hunk #1 FAILED at 51.
Hunk #2 FAILED at 705.
2 out of 2 hunks FAILED -- saving rejects to file
drivers/scsi/arcmsr/arcmsr.h.rej
patching file drivers/scsi/arcmsr/arcmsr_hba.c
Hunk #2 FAILED at 71.
Hunk #3 FAILED at 1329.
Hunk #4 FAILED at 3313.
Hunk #5 succeeded at 3040 with fuzz 2 (offset -670 lines).
Hunk #6 succeeded at 3106 (offset -1780 lines).
Hunk #7 FAILED at 4894.
4 out of 7 hunks FAILED -- saving rejects to file
drivers/scsi/arcmsr/arcmsr_hba.c.rej

James



