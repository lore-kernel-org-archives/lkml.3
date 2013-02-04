Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3BDWKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:10:09 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:61391 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab3BDWKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:10:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130204221356.29548.35746.stgit@dragon>
References: <20130204214952.GJ27963@mtj.dyndns.org>
	<20130204221356.29548.35746.stgit@dragon>
Date: Mon, 4 Feb 2013 14:10:03 -0800
X-Google-Sender-Auth: rPv1-KV4skoG1Mtny2JVSkS1KHU
Message-ID: <CAOS58YO1VSsbisxSqzcW6n=a+XwcM4F0uHN40OKB9Ok6DSMW7A@mail.gmail.com>
Subject: Re: [TRIVIAL PATCH V2] Doc: percpu_counter doc code for better readability
From: Tejun Heo <tj@kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, joe@perches.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 2:14 PM, Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
> Help people reading the percpu_counter code, to notice the ifdef
> else statement that seperates CONFIG_SMP.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Tejun Heo <tj@kernel.org>

Jiri, can you please take this?

Thank you.

-- 
tejun
