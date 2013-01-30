Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab3A3Uul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:50:41 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:43147 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab3A3Uuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:50:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130130204917.GL17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
	<20130130171102.253395279@napanee.usersys.redhat.com>
	<20130130204730.GF8507@mail.hallyn.com>
	<20130130204917.GL17632@redhat.com>
Date: Wed, 30 Jan 2013 12:50:38 -0800
X-Google-Sender-Auth: LUfuZyRxsPot5R17lYTKJYJ2fLM
Message-ID: <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 30, 2013 at 12:49 PM, Aristeu Rozanski > that's not
intentional. thanks for catching this
>
> Tejun, you want me to resubmit the whole series or just the next patch
> (where I was supposed to move that chunk)?

If it doesn't affect the next patch, just posting an updated version
of this patch should be enough, I think. Which tree are these patches
planned to go through?

Thanks.

-- 
tejun
