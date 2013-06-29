Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3F2F5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:57:24 -0400
Received: from mout1.freenet.de ([195.4.92.91]:35666 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab3F2F5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:57:22 -0400
Message-ID: <51CE768C.3030102@01019freenet.de>
Date: Sat, 29 Jun 2013 07:54:20 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it> <20130628181136.52d00e9c@dualc.maya.org> <20130628182533.GT11309@8bytes.org> <51CDD8FD.808@01019freenet.de> <20130628192319.GV11309@8bytes.org>
In-Reply-To: <20130628192319.GV11309@8bytes.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Alex, Andreas,
> 
> On Fri, Jun 28, 2013 at 08:42:05PM +0200, Andreas Hartmann wrote:
>> You're right, there is exactly one entry directly after loading of vfio.
>> I can see this message, too, with linux 3.4.43.
> 
> Can you please test this patch? It should reduce the noise
> significantly, but a few of those error messages are still expected.

Sorry, but it doesn't work for me at all :-(. Behaviour is unchanged. It
is exactly as described in the other mail: at the moment of binding vfio
to 14.0, the fire begins.

echo "1002 4385" > /sys/bus/pci/drivers/vfio-pci/new_id
echo 0000:00:14.0 > /sys/bus/pci/devices/0000:00:14.0/driver/unbind
echo 0000:00:14.0 > /sys/bus/pci/drivers/vfio-pci/bind


Regards,
Andreas
