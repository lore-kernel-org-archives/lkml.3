Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab3GVVE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:04:26 -0400
Received: from www.sr71.net ([198.145.64.142]:36748 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab3GVVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:04:12 -0400
Message-ID: <51ED9E41.3070204@sr71.net>
Date: Mon, 22 Jul 2013 14:04:01 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>  <20130722083721.GC25976@gmail.com> <1374513120.16322.21.camel@misato.fc.hp.com> <51ED9CC2.8040604@gmail.com>
In-Reply-To: <51ED9CC2.8040604@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 01:57 PM, KOSAKI Motohiro wrote:
> 
> One of possible option is to return EINVAL when system has real hotplug
> device.
> I mean this interface is only useful when system don't have proper hardware
> feature and doesn't work correctly hardware property and this interface
> command
> are not consistent.
> 
> Dave, What do you think?

Sounds reasonable to me.
