Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3FMCeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:34:46 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57673 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040Ab3FMCep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:34:45 -0400
Message-ID: <1371090883.1978.61.camel@dabdike>
Subject: Re: [scsi] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 19:34:43 -0700
In-Reply-To: <20130613013032.GA7558@localhost>
References: <20130613013032.GA7558@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 09:30 +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit a256ba092ec57213f96059d41ac5473ff92f5e7c
> Author: Nicholas Bellinger <nab@linux-iscsi.org>
> Date:   Sat May 18 02:40:43 2013 -0700
> 
>     scsi: Split scsi_dispatch_cmd into __scsi_dispatch_cmd setup
>     
>     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

You may be evaluating a bogus branch because no such commit has darkened
the SCSI list, so it obviously can't be on upstream track.

James


