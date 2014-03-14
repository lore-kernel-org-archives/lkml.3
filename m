Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaCNRHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:07:53 -0400
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24880 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaCNRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:07:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,7376"; a="60657259"
X-IronPort-AV: E=Sophos;i="4.97,655,1389772800"; 
   d="scan'208";a="609191139"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        <ath10k@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: add firmware files
References: <20140314084501.23100.13103.stgit@x230>
	<20140314084514.23100.72654.stgit@x230>
	<CAB=NE6WW8yX4kdy02j2fT4g0JvYj4a_XkiqYtXKZSMB7FHuwNg@mail.gmail.com>
Date: Fri, 14 Mar 2014 19:07:29 +0200
In-Reply-To: <CAB=NE6WW8yX4kdy02j2fT4g0JvYj4a_XkiqYtXKZSMB7FHuwNg@mail.gmail.com>
	(Luis R. Rodriguez's message of "Fri, 14 Mar 2014 05:36:53 -0700")
Message-ID: <87ob18ogj2.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:

> On Fri, Mar 14, 2014 at 1:45 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>> + NO LICENSES OR OTHER RIGHTS,
>> +WHETHER EXPRESS, IMPLIED, BASED ON ESTOPPEL OR OTHERWISE, ARE GRANTED
>> +TO ANY PARTY'S PATENTS, PATENT APPLICATIONS, OR PATENTABLE INVENTIONS
>> +BY VIRTUE OF THIS LICENSE OR THE DELIVERY OR PROVISION BY QUALCOMM
>> +ATHEROS, INC. OF THE SOFTWARE.
>
> This -- however is new to linux-firmware -- and I hereby raise a big
> red fucking flag. All other licenses on linux-firmware provide at the
> very least a limited patent grant. What makes Qualcomm special ?

Well, I was just told to use this license with our firmware, I didn't
write this.

-- 
Kalle Valo
