Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab3LKRBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:01:04 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:40785 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3LKRBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:01:01 -0500
Date: Wed, 11 Dec 2013 18:00:47 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <12930742.20131211180047@eikelenboom.it>
To: Avinash Patil <avinashapatil@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: [cfg80211 / iwlwifi] setting wireless regulatory domain doesn't work.
In-Reply-To: <CAJwzM1nwFa7z5gwh42aj39M2dxVXnuecDrhQkVyL+DDFAXwwbg@mail.gmail.com>
References: <1507831110.20131018194349@eikelenboom.it> <792757788.20131023142849@eikelenboom.it> <1819533168.20131211161710@eikelenboom.it> <CAB=NE6V-RSnqbAC-0tfYK=WGJLp1aPC2UpFDurs49h+wXr9UfQ@mail.gmail.com> <CAJwzM1nwFa7z5gwh42aj39M2dxVXnuecDrhQkVyL+DDFAXwwbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Wednesday, December 11, 2013, 5:34:27 PM, you wrote:

> Hi Luis,
>  I have seen that hint during regulatory init still has request processed set to false. This results into further request set to pending. I have sent a patch for the same last week. Please have a look- I think issue faced by me is similar to what Sander is same.
> Thanks,
> Avinash.

Hi Avinash,

Could you send me the patch (or a link to it), i can't find it on the linux-wireless list.

--
Sander


>  On Dec 11, 2013 9:14 PM, "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>  On Wed, Dec 11, 2013 at 4:17 PM, Sander Eikelenboom
>  <linux@eikelenboom.it> wrote:
 >> Since i haven't got a response to this yet and after having the troubled machine back:
 >> The problem is still present in linux 3.13-rc3
>  
>  Keep in mind regulatory hints for Intel or Atheros cards do nothing
>  other than help compliance further given that the cards already have
>  their own regulatory data, the user input / hint is only going to
>  reduce the card's channels further. That said the fact that you are
>  not seeing a regulatory domain being set is an issue provided you have
>  CRDA installed or use CONFIG_CFG80211_INTERNAL_REGDB. Keep in mind
>  that the latest version of wireless-regdb had a signature issue
>  reported by users and not sure if that is cleared yet, so that would
>  also prevent the wireless-regdb being read even if CRDA was present.
>  To rule that out try putting the db.txt into net/wireless/db.txt and
>  compile with CONFIG_CFG80211_INTERNAL_REGDB for now.
>  
>  Then send the dmesg output, no need for all that fluffy intel debug
>  log as its not useful in this case.
>  
>    Luis
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  

