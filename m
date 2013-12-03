Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3LCRxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:53:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3LCRxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:53:42 -0500
Message-ID: <529E1AA1.9000202@infradead.org>
Date: Tue, 03 Dec 2013 09:53:37 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unnecessarily gendered language
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com> <CAMuHMdXcHTTmnqCTJWRJU_2vgv3wtB9gFGiR5Z0GF=BDKniXCg@mail.gmail.com>
In-Reply-To: <CAMuHMdXcHTTmnqCTJWRJU_2vgv3wtB9gFGiR5Z0GF=BDKniXCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/13 01:04, Geert Uytterhoeven wrote:
> Disclaimer: didn't read through all of it.
> 
> On Tue, Dec 3, 2013 at 2:18 AM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
>> --- a/drivers/scsi/mesh.c
>> +++ b/drivers/scsi/mesh.c
>> @@ -1190,8 +1190,8 @@ static void handle_msgin(struct mesh_state *ms)
>>                         if (tp->sdtr_state != sdtr_sent) {
>>                                 /* reply with an SDTR */
>>                                 add_sdtr_msg(ms);
>> -                               /* limit period to at least his value,
>> -                                  offset to no more than his */
>> +                               /* limit period to at least its value,
>> +                                  offset to no more than its */
>>                                 if (ms->msgout[3] < ms->msgin[3])
>>                                         ms->msgout[3] = ms->msgin[3];
>>                                 if (ms->msgout[4] > ms->msgin[4])
> 
> I think both occurrences of "his" should actually be "this".
> 
> BTW, the singular they  ("The caller must know what they are doing!")
> feels a bit strange to me, but it seems to match the wikipedia article on
> singular they. As a non-native English speaker, I was not familiar with it.

I understand, since as a native English speaker I was not familiar with it either,
and I still don't like it.  ;)


-- 
~Randy
