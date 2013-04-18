Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968249Ab3DRKvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:51:44 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62399 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967094Ab3DRKvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:51:43 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.125.78]
In-Reply-To: <1366133111-5412-1-git-send-email-s-anna@ti.com>
References: <1366133111-5412-1-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 18 Apr 2013 13:51:21 +0300
Message-ID: <CAK=WgbbfT=Ft3GnN1W5A4fg8BDrypgvfeiM3zoRMbW=JS8m+6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: fix kconfig dependencies for VIRTIO
To: Suman Anna <s-anna@ti.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 8:25 PM, Suman Anna <s-anna@ti.com> wrote:
> remoteproc configuration selects VIRTIO, but VIRTIO is now
> subordinate to VIRTUALIZATION. VIRTUALIZATION has to be
> selected as well to honor the kconfig menu hierarchy and fix
> the dependency warnings.

Thanks Suman. Is this stable material as well or not relevant before 3.9?
