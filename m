Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaKTAH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:07:56 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55769 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbaKTAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:07:55 -0500
Date: Thu, 20 Nov 2014 00:07:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        Ian Campbell <Ian.Campbell@citrix.com>, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com
Subject: Re: [PATCH v9 05/13] arm: introduce is_device_dma_coherent
Message-ID: <20141120000736.GN4042@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
 <1415792454-23161-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1411141158560.26318@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1411181649000.27247@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411181649000.27247@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 04:49:21PM +0000, Stefano Stabellini wrote:
> ping?

Sending something which wants my attention _To:_ me is always a good idea :)

The patch is fine in itself, but I have a niggle about the
is_device_dma_coherent() - provided this is only used in architecture
specific code, that should be fine.  It could probably do with a comment
to that effect in an attempt to discourage drivers using it (thereby
becoming less portable to other architectures.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
