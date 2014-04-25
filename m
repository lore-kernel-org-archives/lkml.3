Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaDYPob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:44:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaDYPo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:28 -0400
Message-ID: <1398440433.4152.22.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 0/2 v3] cfg80211: The very first steps to support
 5/10MHz channels in 5.9Ghz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Fri, 25 Apr 2014 17:40:33 +0200
In-Reply-To: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140415_143803_281449_E72A76A1)
References: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140415_143803_281449_E72A76A1)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 14:37 +0200, Rostislav Lisovy wrote:
> The IEEE 802.11p amendment specifies usage of 5 and 10 MHz wide
> channels in 5.9GHz band for vehicular environment. This patch-set
> adds new channel attributes holding the information about the
> prohibited bandwidths. This is meant to be used mainly with
> channels in 5.9GHz band in future implementation of 802.11p.

Both applied.

johannes

