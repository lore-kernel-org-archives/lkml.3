Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaIROyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:54:31 -0400
Received: from fep26.mx.upcmail.net ([62.179.121.46]:61716 "EHLO
	fep26.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbaIROya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:54:30 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <541AF222.7080308@odi.ch>
Date: Thu, 18 Sep 2014 16:54:26 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] nouveau regression: ext monitor dead after resume
References: <541AE737.8070009@odi.ch>
In-Reply-To: <541AE737.8070009@odi.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tried and reverted these commits but to no avail.

028791bb7d6 drm/nouveau/kms: restore fbcon after display has been resumed
456b0579fb0 drm/nouveau: use connector events for HPD instead of GPIO watching

