Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaC1Iuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:50:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:48114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaC1Iu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:50:28 -0400
Message-ID: <1395996624.4175.8.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 0/5] cfg80211: Add channel attributes to be used with
 5/10MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Fri, 28 Mar 2014 09:50:24 +0100
In-Reply-To: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140311_140522_704622_0C67DCB5)
References: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140311_140522_704622_0C67DCB5)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 14:05 +0100, Rostislav Lisovy wrote:
> The IEEE 802.11p amendment specifies usage of 5 and 10 MHz wide
> channels in 5.9GHz band for vehicular environment. This patch-set adds
> new channel attributes holding the information about the prohibited
> bandwidths. This is meant to be used mainly with channels in 5.9GHz
> band in future implementation of 802.11p.

This looks fine, but you need to rebase. Also, maybe squash patches 1/2
or something, the patches are pretty oddly split up IMHO, with nl80211.h
updates in one patch and the nl80211.c in the other, for example.

It'd also be good to have some text in the empty commit logs of patches
3 and 5.

johannes

