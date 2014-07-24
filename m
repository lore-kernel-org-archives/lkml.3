Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaGXKqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaGXKqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:46:18 -0400
Message-ID: <53D0E3F3.6050206@redhat.com>
Date: Thu, 24 Jul 2014 12:46:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: uobergfe@redhat.com, dzickus@redhat.com, akpm@linux-foundation.org,
        mingo@redhat.com
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
References: <1406196811-5384-1-git-send-email-drjones@redhat.com> <1406196811-5384-3-git-send-email-drjones@redhat.com>
In-Reply-To: <1406196811-5384-3-git-send-email-drjones@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/07/2014 12:13, Andrew Jones ha scritto:
> 
> The running kernel still has the ability to enable/disable at any
> time with /proc/sys/kernel/nmi_watchdog us usual. However even
> when the default has been overridden /proc/sys/kernel/nmi_watchdog
> will initially show '1'. To truly turn it on one must disable/enable
> it, i.e.
>   echo 0 > /proc/sys/kernel/nmi_watchdog
>   echo 1 > /proc/sys/kernel/nmi_watchdog

Why is it hard to make this show the right value? :)

Paolo

