Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaFHMGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:06:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbaFHMGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:06:48 -0400
Message-ID: <539451CD.3060806@redhat.com>
Date: Sun, 08 Jun 2014 14:06:37 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, shemminger@osdl.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH 1/7] lib/random32.c: Mark self-test data as __initconst
References: <20140607081934.9387.qmail@ns.horizon.com>
In-Reply-To: <20140607081934.9387.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 10:19 AM, George Spelvin wrote:
> So it can be thrown away along with the code that uses it.
>
> Signed-off-by: George Spelvin <linux@horizon.com>

Fine by me.

Acked-by: Daniel Borkmann <dborkman@redhat.com>
