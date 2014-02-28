Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaB1Lz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:55:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbaB1LzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:55:25 -0500
Message-ID: <1393588511.3364.28.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v3 1/4] vmbus: add missing breaks
From: Gerd Hoffmann <kraxel@redhat.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kys@microsoft.com, abgupta@microsoft.com,
        haiyangz@microsoft.com, jasowang@redhat.com,
        devel@linuxdriverproject.org
Date: Fri, 28 Feb 2014 12:55:11 +0100
In-Reply-To: <53105171.1060102@ti.com>
References: <1393247831-5271-1-git-send-email-kraxel@redhat.com>
	 <1393247831-5271-2-git-send-email-kraxel@redhat.com>
	 <53105171.1060102@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why is this sent to fbdev list? Is this related to the hyperv-fb patches?

Yes, the hyperv-fb patches depend on this one.

Greg has picked it up meanwhile, that's why v4 + v5 of the patch series
don't include it any more.

cheers,
  Gerd


