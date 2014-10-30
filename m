Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbaJ3HMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:12:07 -0400
Received: from svenfoo.org ([82.94.215.22]:45764 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaJ3HMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:12:06 -0400
Message-ID: <5451E4C1.3000704@zonque.org>
Date: Thu, 30 Oct 2014 08:12:01 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, teg@jklm.no,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>	<20141029221505.GA7812@kroah.com> <87egtqurrp.fsf@x220.int.ebiederm.org>
In-Reply-To: <87egtqurrp.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 05:04 AM, Eric W. Biederman wrote:
> For what it is worth these patches are also poorly split up.  Every
> patch I looked at in detail had functions that were being introduced
> that did not have callers.

Yes, we wanted to keep the reply threading cleaner and the individual
patches short. With a patch set that avoids introducing functions
without callers, each patch would have grown substantially. But I know
that's unusual to do it that way.

> That poor split up of the patches makes it difficult to see how
> the functionality that is being introduced is being used.

Ok, I see. For now, I think it's probably easiest to pull the patches
from here, and then look at the resulting files directly:


https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/log/?h=kdbus

Other than that, please give us some time to respond to your longer
reply. Thanks for taking the time to write this up!


Daniel

