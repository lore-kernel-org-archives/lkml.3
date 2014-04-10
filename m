Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbaDJR05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:26:57 -0400
Received: from nbd.name ([46.4.11.11]:55213 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaDJR04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:26:56 -0400
Message-ID: <5346D456.3010504@openwrt.org>
Date: Thu, 10 Apr 2014 19:26:46 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>	 <53451077.2030102@openwrt.org> (sfid-20140409_111854_192527_B5A21A7B) <1397150173.4757.25.camel@jlt4.sipsolutions.net>
In-Reply-To: <1397150173.4757.25.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-10 19:16, Johannes Berg wrote:
> On Wed, 2014-04-09 at 11:18 +0200, Felix Fietkau wrote:
> 
>> I'm looking forward to getting rid of patches for older kernels that
>> often get in the way when using various wireless-testing versions ;)
> 
> What do you frequently get conflicts on? I haven't seen any for a long
> time.
I don't remember. It was in different areas every time I did an update.

- Felix
