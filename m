Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152Ab3IEL4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:56:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57395 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3IEL4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:56:38 -0400
Date: Thu, 5 Sep 2013 13:56:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-dev@lists.linaro.org,
        len.brown@intel.com, rjw@sisk.pl, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] PM / Hibernate: add section for resume options
Message-ID: <20130905115636.GB15161@amd.pavel.ucw.cz>
References: <1377114413-8521-1-git-send-email-sebastian.capella@linaro.org>
 <1377114413-8521-3-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377114413-8521-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-08-21 12:46:53, Sebastian Capella wrote:
> Expand the existing documentation to explicitly list the options for
> resuming a hibernation image, including the manual resume option which
> can be used from the initrd or initramfs and the kernel init resume.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
