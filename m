Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3BMSrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:47:11 -0500
Received: from smtp-153-wednesday.nerim.net ([194.79.134.153]:56218 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756801Ab3BMSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:47:08 -0500
Date: Wed, 13 Feb 2013 19:47:06 +0100
From: Damien Wyart <damien.wyart@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
Message-ID: <20130213184706.GA23803@brouette>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
 <20130213061853.GA4043@brouette>
 <CAKfTPtDCPKeQpcS4mQc7Jp7+wK2EuvnCUqAzL7SOELVVL3jztw@mail.gmail.com>
 <20130213092154.GA4481@brouette>
 <CAKfTPtDprVAA0o6sTugYk8RiaUkGXUmSvd4RJbTEhNkKj7B-5A@mail.gmail.com>
 <20130213140843.GA21308@brouette>
 <CAKfTPtCuj4xZi2mBZP_Vz-zzySwBLKPn2aNkdqf6g8sVJoyS+A@mail.gmail.com>
 <CAKfTPtDrTyof40Lk7MzdqEon2dkN=RZNEvP5BQSJVKP-EYsCXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDrTyof40Lk7MzdqEon2dkN=RZNEvP5BQSJVKP-EYsCXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vincent Guittot <vincent.guittot@linaro.org> [2013-02-13 18:49]:
> I have look into Frederic's tree but i didn't find any reason that
> could explain your problem. May be Frederic will have some ideas
> I have also tested his branch with and without my patch and both
> kernel are booting (on an ARM platform without using the full_nohz
> feature ). I have faced a conflict when i have applied my patch on his
> branch as we insert code at the same place. You should have faced the
> same conflict. How have you solved it ?

Bingo, that was the problem in my setup: as the patch was applied
through a script with others, I had missed the error message about the
conflict (I have also another conflict which can be safely ignored so
the new one did not catch my eye)... So the patch was only half-applied,
and the final code is broken.

How did you solve the conflict (I am not a scheduler expert)? I can
retry running the patched kernel with your resolution, to check if
everything is ok.


Thanks and sorry for this,
-- 
Damien
