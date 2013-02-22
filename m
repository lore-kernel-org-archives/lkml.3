Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab3BVRIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:08:02 -0500
Received: from mx0.parallels.com ([199.115.104.20]:37892 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3BVRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:08:00 -0500
Message-ID: <5127A607.3040603@parallels.com>
Date: Fri, 22 Feb 2013 21:08:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Tejun Heo" <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
References: <1361550000-14173-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.02.1302221034380.7600@gentwo.org> <alpine.DEB.2.02.1302221057430.7600@gentwo.org> <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
In-Reply-To: <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 09:01 PM, Christoph Lameter wrote:
> Argh. This one was the final version:
> 
> https://patchwork.kernel.org/patch/2009521/
> 

It seems it would work. It is all the same to me.
Which one do you prefer?


