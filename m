Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbaGRI5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:57:47 -0400
Received: from ozlabs.org ([103.22.144.67]:44672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaGRI5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:57:43 -0400
Message-ID: <1405673860.13852.1.camel@concordia>
Subject: Re: perf: Add support for full Intel event lists v7
From: Michael Ellerman <mpe@ellerman.id.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org
Date: Fri, 18 Jul 2014 18:57:40 +1000
In-Reply-To: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 16:59 -0700, Andi Kleen wrote:
> All feedback addressed. Hopefully ready for merge now.
...

> The JSON format and perf parser has some minor Intelisms, but they
> are simple and small and optional. It's easy to extend, so it would be
> possible to use it for other CPUs too, add different pmu attributes, and
> add new download sites to the downloader tool.

Yeah I agree.

We'll do some follow-up patches to get it working for the IBM powerpc chips.

cheers


