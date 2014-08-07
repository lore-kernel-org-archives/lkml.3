Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaHGGCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:02:55 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58192 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaHGGCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:02:53 -0400
Date: Thu, 7 Aug 2014 08:02:15 +0200
From: Antoine Schweitzer-Chaput <antoine@schweitzer-chaput.fr>
To: A Raghavendra Rao <raghav3276@gmail.com>
Cc: gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com, c@24.io,
        devel@driverdev.osuosl.org, A Raghavendra Rao <arrao@cdac.in>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192u: fix sparse warnings in r8192U_core.c
Message-ID: <20140807060215.GA8940@buck.home>
References: <1407386447-16308-1-git-send-email-arrao@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407386447-16308-1-git-send-email-arrao@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V02:K0:Fu8DlUP7e/9ng61X/XwdABltf+G/LLf2/R5BsgUMURD
 hBP4e7H0QAG5xQFu0ubvogrsbnlHtKG5ZyLwDFVgJnd5oPty+j
 4T1cDbdm5xJpFectsM+ZLoYn8j6qVgtUHa+aowvbHg7NcK/bxm
 6ca6f7ypKhwxLJJRJC8OPeSlhBo8Ga4kjdEqZxoC7Vo/vTRjrp
 jjjInLew3jRzw1IszTCRfIpihx1eweBUeeLHiNTTkQQYhh7FTc
 Ne9s1KUxvbrEtgN8GCM4IsWZ256yZIVArUB9l1S2LUvsvcFmrN
 n/yixYcW0xy1E78gUu/5EsQ26GTz0btZULb95US5IvkAxst+6H
 BViMMWUGi5pPHNbxN0fY6HB6uwPn+b9FJxwNJBwlb
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:10:47AM +0530, A Raghavendra Rao wrote:
> Signed-off-by: A Raghavendra Rao <arrao@cdac.in>

This looks very similar to what I submitted on July 31st.
At this time Greg had additional comments which led to a quite different
patchset (though its review is not completed yet), you may find interesting
to review this whole thread.

Antoine
