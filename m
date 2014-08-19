Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaHSJCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:02:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38001 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaHSJCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:02:04 -0400
Date: Tue, 19 Aug 2014 11:02:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-pm@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        Terje =?iso-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v3 2/3] drm/tegra: Request memory bandwidth for the
 display controller
Message-ID: <20140819090201.GB7862@amd>
References: <1408437523-8542-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408437523-8542-3-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408437523-8542-3-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-08-19 10:38:42, Tomeu Vizoso wrote:
> For now the amount requested is based solely on the current mode's refresh
> rate.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
