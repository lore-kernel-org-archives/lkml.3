Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3A3TNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:13:07 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:54898 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3A3TNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <CALiWzOhawsfaW9TQgn-CZO5XQ_2=1R_91QB9q4yM1HDq_yQRFg@mail.gmail.com>
References: <20130128225657.GA17533@kashmir> <0BA3FCBA62E2DC44AF3030971E174FB301925D7A@HASMSX103.ger.corp.intel.com>
 <CALiWzOhawsfaW9TQgn-CZO5XQ_2=1R_91QB9q4yM1HDq_yQRFg@mail.gmail.com>
From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Date: Wed, 30 Jan 2013 20:12:22 +0100
X-Google-Sender-Auth: X28s0SH73ARCZbA0ZQBHC5aSvPw
Message-ID: <CALiWzOiO9Bj=kJh8=Dzfph7mhu8bKowdmV-CeoaLMX8n--6pGw@mail.gmail.com>
Subject: Re: [Ilw] iwlwifi/iwldvm soft lockup with 3.8.0-rc5 (was: almost
 unusable on 3.8.0-rc5)
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:14 AM, Mathieu Chouquet-Stringer
<mathieu@csetco.com> wrote:
> On Tue, Jan 29, 2013 at 8:16 AM, Grumbach, Emmanuel
> <emmanuel.grumbach@intel.com> wrote:
>> Please try this one:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=c3e5d7181afb66657393066bccce0956fab09ab3
>>
>> as you can see, it is in mainline already.
>
> Ha, that was fast!  I'll check tonight, thanks for your quick turn around.

Issue is indeed fixed: thank you!
