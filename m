Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaFJJaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:30:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFJJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:30:22 -0400
Date: Tue, 10 Jun 2014 11:30:11 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3.4 82/88] xen/setup: Populate freed MFNs from non-RAM
 E820 entries and gaps to E820 RAM
Message-ID: <20140610093011.GL15989@olila.local.net-space.pl>
References: <20140610002424.500996570@linuxfoundation.org>
 <20140610002427.192691272@linuxfoundation.org>
 <5396CACF.6050801@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5396CACF.6050801@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:07:27AM +0100, David Vrabel wrote:
> On 10/06/14 01:25, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
>
> This is a new feature and not a bug fix.  I don't think it (and patches
> 83-85) are suitable for stable.

IIRC, this is the main patch fixing dom0 memory looses.
Earlier patches are preparatory stuff and later ones are
fixing bugs introduced by this patch and others. Konrad and I
picked only minimal set of patches to fix that issue in 3.4.

Daniel
