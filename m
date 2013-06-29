Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3F2JJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 05:09:22 -0400
Received: from mout2.freenet.de ([195.4.92.92]:35402 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab3F2JJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 05:09:21 -0400
Message-ID: <51CEA389.9070901@01019freenet.de>
Date: Sat, 29 Jun 2013 11:06:17 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it> <20130628181136.52d00e9c@dualc.maya.org> <20130628182533.GT11309@8bytes.org> <51CDD8FD.808@01019freenet.de> <20130628192319.GV11309@8bytes.org> <51CE768C.3030102@01019freenet.de> <20130629080447.GX11309@8bytes.org>
In-Reply-To: <20130629080447.GX11309@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel schrieb:
> On Sat, Jun 29, 2013 at 07:54:20AM +0200, Andreas Hartmann wrote:
>> Sorry, but it doesn't work for me at all :-(. Behaviour is unchanged. It
>> is exactly as described in the other mail: at the moment of binding vfio
>> to 14.0, the fire begins.
>
> Hmm, VFIO attaches the device to a new domain. That clears the bit, how
> about this patch:

Didn't help, too :-(


Regards,
Andreas
