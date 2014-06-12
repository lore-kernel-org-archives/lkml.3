Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaFLV2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:28:55 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:39947 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaFLV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <1402598718.12385.16.camel@joe-AO725>
References: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com>
 <20140611093447.GL7772@pathway.suse.cz> <1402596066.2627.1.camel@buesod1.americas.hpqcorp.net>
 <1402598718.12385.16.camel@joe-AO725>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 12 Jun 2014 14:28:32 -0700
X-Google-Sender-Auth: QaH5zCu6OK_S1ZHpP2zutOC28ww
Message-ID: <CAB=NE6X+PiTDk5xQxu00AGzr3hwSdv_f=W+HY1EDewgTu-EN9w@mail.gmail.com>
Subject: Re: [RFC] printk: allow increasing the ring buffer depending on the
 number of CPUs
To: Joe Perches <joe@perches.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Chris Metcalf <cmetcalf@tilera.com>,
        =?UTF-8?B?UGV0ciBNbMOhZGVr?= <pmladek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:45 AM, Joe Perches <joe@perches.com> wrote:
>
> trivia: s/loosing/losing/

Amended, thanks.

  Luis
