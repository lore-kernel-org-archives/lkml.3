Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbbAIQkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:40:35 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55931 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751725AbbAIQke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:40:34 -0500
Date: Fri, 9 Jan 2015 16:40:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: drm: armada: armada_output:  Remove some unused
 functions
Message-ID: <20150109164022.GT12302@n2100.arm.linux.org.uk>
References: <1420232102-2935-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420232102-2935-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 09:55:02PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> armada_drm_encoder_mode_fixup() armada_drm_encoder_commit() armada_drm_encoder_prepare()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Thanks, I've queued this and your other patch for David for the next
merge window; I don't see them as urgent patches.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
