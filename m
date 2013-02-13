Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3BMDpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:45:45 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:58692 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3BMDpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:45:44 -0500
Message-ID: <1360726523.3642.4.camel@thor.lan>
Subject: Re: [ 61/61] drm/nouveau: add lockdep annotations
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel J Blueman <daniel@quora.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Date: Tue, 12 Feb 2013 22:35:23 -0500
In-Reply-To: <20130212203426.021116247@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
	 <20130212203426.021116247@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 12:35 -0800, Greg Kroah-Hartman wrote:
> 3.7-stable review patch.  If anyone has any objections, please let me know.

FWIW, I never saw this on 3.7 but it happened 1st time on 3.8-rcX
I haven't tested this fix either.

Regards,
Peter Hurley


