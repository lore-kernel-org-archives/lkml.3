Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3AYSe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:34:56 -0500
Received: from longford.logfs.org ([213.229.74.203]:58387 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3AYSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:34:54 -0500
Date: Fri, 25 Jan 2013 12:12:55 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mpt2sas: prevent double free on error path
Message-ID: <20130125171255.GA22141@logfs.org>
References: <20130123212033.GA15800@logfs.org>
 <87k3r310jr.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k3r310jr.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 January 2013 08:51:20 +0100, Bjørn Mork wrote:
> 
> How about the copy of this code in drivers/scsi/mpt3sas/mpt3sas_scsih.c?
> Is that safe, or does it need fixing as well?

Well spotted, that appears to suffer from the same ailment.  Will cook
up a second patch for that.

Are there any other copies of this code around?

Jörn

--
The object-oriented version of 'Spaghetti code' is, of course, 'Lasagna code'.
(Too many layers).
-- Roberto Waltman.
