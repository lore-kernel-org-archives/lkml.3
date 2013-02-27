Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3B0KDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:03:48 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:34664 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3B0KDr (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 27 Feb 2013 05:03:47 -0500
Message-Id: <512DE80F02000078000C1650@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 27 Feb 2013 10:03:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?Q?Roger=20Pau=20Monn=C3=A9?=" <roger.pau@citrix.com>
Cc: "Chen Gang" <gang.chen@asianux.com>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "dgdegra@tycho.nsa.gov" <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/xen-blkback: preq.dev is used
 without initialized
References: <512D90F2.9070200@asianux.com> <512DD6DA.5010706@citrix.com>
In-Reply-To: <512DD6DA.5010706@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.02.13 at 10:50, Roger Pau Monné<roger.pau@citrix.com> wrote:
> On 27/02/13 05:52, Chen Gang wrote:
>> 
>>   if call xen_vbd_translate failed, the preq.dev will be not initialized.
>>   so use blkif->vbd.pdevice instead (still better to print relative info).
> 
> preq.dev is initialized a a couple of lines prior to calling
> xen_vbd_translate:
> 
> preq.dev           = req->u.rw.handle;

Not anymore after 01c681d4c70d64cb72142a2823f27c4146a02e63
(in Konrad's tree).

Jan
