Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3A2J5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:57:18 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:50381 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693Ab3A2J5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:57:11 -0500
Message-ID: <1359453426.1345.30.camel@x61.thuisdomein>
Subject: Re: [PATCH v3] qla2xxx: silence two GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 29 Jan 2013 10:57:06 +0100
In-Reply-To: <CC98F9D4.ECE6%saurav.kashyap@qlogic.com>
References: <CC98F9D4.ECE6%saurav.kashyap@qlogic.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Jan 2013 09:57:06.0027 (UTC) FILETIME=[FEB6E3B0:01CDFE06]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 11:15 -0500, Saurav Kashyap wrote:
> Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> 
> Thanks,
> ~Saurav
> 
> >Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
> >warnings:
> >    drivers/scsi/qla2xxx/qla_gs.c: In function Œqla2x00_fdmi_rhba¹:
> >    drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript is
> >above array bounds [-Warray-bounds]
> >    drivers/scsi/qla2xxx/qla_gs.c: In function Œqla2x00_fdmi_register¹:
> >    drivers/scsi/qla2xxx/qla_gs.c:1663:15: warning: array subscript is
> >above array bounds [-Warray-bounds]

This patch was originally posted to silence two GCC warnings while
building v3.6-rc7. Basically identical warnings can still be seen while
building v3.8-rc5. What's the status of this patch?


Paul Bolle

