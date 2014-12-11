Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaLKEpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:45:36 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46482 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbaLKEpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:45:35 -0500
Message-ID: <1418273120.8310.20.camel@HansenPartnership.com>
Subject: Re: [v3.16][v3.17][v3.18][ Regression]  scsi: handle flush errors
 properly
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: steven@qumulo.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Date: Thu, 11 Dec 2014 07:45:20 +0300
In-Reply-To: <5488C478.9000209@canonical.com>
References: <5488C478.9000209@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 17:08 -0500, Joseph Salisbury wrote:
> Hello James,
> 
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:

If I read this bug report correctly, it's saying a USB attached device
produces an error when doing a "shred" but the same device PCI attached
doesn't.  Presumably shred sends some type of zero length command USB
storage doesn't like.  What is shred actually doing (what commands is it
sending)?

James


