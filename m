Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaLKSUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:20:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaLKSUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:20:06 -0500
Date: Thu, 11 Dec 2014 18:37:58 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com,
        brouer@redhat.com
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
Message-ID: <20141211183758.22e224a0@redhat.com>
In-Reply-To: <20141210163017.092096069@linux.com>
References: <20141210163017.092096069@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Warning, I'm getting crashes with this patchset, during my network load testing.
I don't have a nice crash dump to show, yet, but it is in the slub code.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
