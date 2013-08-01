Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab3HAWPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:15:04 -0400
Received: from smtp103.biz.mail.gq1.yahoo.com ([98.137.12.178]:38378 "HELO
	smtp103.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756418Ab3HAWPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:15:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: x2Co1LgVM1kb_w18UTItl25IsmvFjDQZ_AtTDaAc34cjKrg
 nfLswn88Kc0LM80WskGt8ZO3kcDwmS_2jMBWI6yeCb0nCQ1IVlyJIMCyiRKe
 tFRauoECZsGoTve5DhdQGpzsIN7vj8dxEvRKN4psgM0LO6wkM2dAHWc1I.h0
 652SJ4SYlmME9H1KTYVSbbCO.2JU0n1ZP_5j2c1LjRjBn1uxuwHJRSrqvoXC
 wO0hX7E5.teyHFW9Wwki0fVuWn.PoRaaOm54cNJ_EwshecpxqghDo7MT4gqK
 dUyXBcguIgSsD84SNWmu0wBqMQ2VEg80YCKq8iLGhsnkG_SPPd9SCGWYICQB
 XjIpZtXgYJ5mxk0WnB_ce3sha3g1efXydhfOh0QzB4IrOQx4.D042G.W64as
 klfJDKlUkLoIDSbicI9EyrIekllszzO.wB77bnKgPC6Ry_NSqhlUp1a6gXzV
 41WkxNHJN84vKD9UwvnYOw1uvFV2QOr0moHl8_fKZ60tYLGCItoa_kguxfv2
 qQAR3KiT_H9xFmTGFck0nkFMWcMoYg7s-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp103.biz.mail.gq1.yahoo.com with SMTP; 01 Aug 2013 15:15:00 -0700 PDT
Message-ID: <51FADDE4.8080805@schaufler-ca.com>
Date: Thu, 01 Aug 2013 15:15:00 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v14 3/6] LSM: Explicit individual LSM associations
References: <51F16CFB.6040603@schaufler-ca.com> <1991449.AFacmybWrj@sifl> <51FAAE5E.4060801@schaufler-ca.com> <1875185.QyWUQZtYy0@sifl>
In-Reply-To: <1875185.QyWUQZtYy0@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2013 2:30 PM, Paul Moore wrote:
> On Thursday, August 01, 2013 11:52:14 AM Casey Schaufler wrote:
>> On 8/1/2013 11:35 AM, Paul Moore wrote:
>>> Okay, so if I understand everything correctly, there are no new entries in
>>> /proc relating specifically to NetLabel, XFRM, or Secmark; although there
>>> are new LSM specific entries for the general /proc entries that exist
>>> now.  Yes?
>> That's correct.
>>
>> There is /sys/kernel/security/present, which tells you which LSM is going to
>> show up in /proc/.../attr/current.
>>
>> Should we have /sys/kernel/security/XFRM, /sys/kernel/security/secmark,
>> /sys/kernel/security/NetLabel and /sys/kernel/security/SO_PEERCRED?
> Maybe.
>
> While they might be helpful, I'm not 100% certain they are needed and further 
> I'm not sure they are the "right" solution at this point.  Any thoughts, both 
> for and against, are welcome.
>
What might be a more correct solution? Assuming, of course, that there's
a real problem.


