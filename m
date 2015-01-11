Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbbAKUXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:23:09 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:57303 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAKUXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:23:07 -0500
MIME-Version: 1.0
In-Reply-To: <20150111201448.GA4214@localhost.localdomain>
References: <1421005263-24530-1-git-send-email-ddecotig@gmail.com> <20150111201448.GA4214@localhost.localdomain>
From: David Decotigny <ddecotig@gmail.com>
Date: Sun, 11 Jan 2015 12:22:46 -0800
X-Google-Sender-Auth: SG0QMaLU1_D_81ZH_8T6ulECYyA
Message-ID: <CAG88wWa2F56VgiUdhcFK0TLA8-BcFpYkyH0AbzTFV0cWUYnw=w@mail.gmail.com>
Subject: Re: [PATCH net-next v1] doc: net: fix txtimestamp build
To: Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch, Willem has a better fix pending:
http://patchwork.ozlabs.org/patch/427384/

Sorry for the spam.

PS: I didn't notice netdev was not a recipient (was using
get_maintainer script too blindly), thanks for telling me.

On Sun, Jan 11, 2015 at 12:14 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Sun, Jan 11, 2015 at 11:41:03AM -0800, David Decotigny wrote:
>> From: David Decotigny <decot@googlers.com>
>
> FYI, patches for 'net-next' need to be addressed to both the
> networking list and to the maintainer.
>
> Thanks,
> Richard
