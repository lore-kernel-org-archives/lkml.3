Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab3DPVRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:17:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965219Ab3DPVRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:17:33 -0400
Subject: Re: [PATCH] kvm: Allow build-time configuration of KVM device assignment
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20130416194605.23183.31789.stgit@bling.home>
Date: Tue, 16 Apr 2013 23:17:30 +0200
Cc: mtosatti@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <59C4E05D-C3B5-4BDB-9285-D0CE8C30AFB7@suse.de>
References: <20130416194605.23183.31789.stgit@bling.home>
To: Alex Williamson <alex.williamson@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16.04.2013, at 21:49, Alex Williamson wrote:

> We hope to at some point deprecate KVM legacy device assignment in
> favor of VFIO-based assignment.  Towards that end, allow legacy
> device assignment to be deconfigured.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Definitely a step into the right direction. And it should also fix a build error that I experienced with CONFIG_IOMMU and CONFIG_KVM on ppc and arm.


Reviewed-by: Alexander Graf <agraf@suse.de>

