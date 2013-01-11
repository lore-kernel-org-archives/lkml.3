Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3AKTPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:15:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab3AKTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:15:47 -0500
Date: Fri, 11 Jan 2013 17:13:55 -0200
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/2] Mempressure cgroup
Message-ID: <20130111171355.3f5cf87e@doriath.home>
In-Reply-To: <20130104082751.GA22227@lizard.gateway.2wire.net>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2013 00:27:52 -0800
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> - I've split the pach into two: 'shrinker' and 'levels' parts. While the
>   full-fledged userland shrinker is an interesting idea, we don't have any
>   users ready for it, so I won't advocate for it too much.

For the next version of the automatic balloon prototype I'm planning to give
the user-space shrinker a try. It seems to be a better fit, as the current
prototype has to guess by how much a guest's balloon should be inflated.

Also, I think it would be worth it to list possible use-cases for the two
functionalities in the series' intro email. This might help choosing both,
one or another.

Looking forward to the next version :)
