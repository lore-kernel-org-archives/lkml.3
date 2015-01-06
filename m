Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbbAFDTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:19:08 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:40079 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbbAFDTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:19:04 -0500
Message-ID: <54AB5425.3010609@hurleysoftware.com>
Date: Mon, 05 Jan 2015 22:19:01 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Epler <jepler@unpythonic.net>, linux-kernel@vger.kernel.org
Subject: Re: What are these weird line-noise signatures?
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com> <CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com> <5463FE5E.906@rock-chips.com> <A2CA0424C0A6F04399FB9E1CD98E0304845059B3@US01WEMBX2.internal.synopsys.com> <20150106025749.GA41958@unpythonic.net>
In-Reply-To: <20150106025749.GA41958@unpythonic.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 10:12 PM, Jeff Epler wrote:
> I have seen similar "signatures" that have the appearance of good old
> fashioned line noise, such as in this recent message from Paul
> Zimmerman (but not in all of his messages either!):
> 
> On Tue, Jan 06, 2015 at 01:23:30AM +0000, Paul Zimmerman wrote:
> [real content snipped]
>> -- 
>> Paul
>>
>> N?????r??y????b?X??ǧv?^?){.n?+????{????zX??^W??ܨ}???Ơz?&j:+v???^G????zZ+??+zf???h???~????i???z?^^?w?????????&?)ߢ^[f??^jǫy?m??@A?a??^??^L0??h?^O??i^?
> (some characters were control characters and are represented with carets
> above, and my mailreader seems to have transcoded other non-ASCIIs as
> reencoded by my mailreader, but it's hard to be sure)
> 
> I have seen them from senders at various domains, and they are not some
> kind of artifact of my own mail system because they appear in the
> archives e.g., at
> 
> http://article.gmane.org/gmane.linux.usb.general/120149
> 
> and similarly in a 2014 message from another poster at another domain:
> [real content snipped again]
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> N?????r??y????b?X??ǧv?^?) .n?+????{????zX??^W??ܨ}???Ơz?&j:+v???^G????zZ+??+zf???h???~????i???z?^^?w?????????&?)ߢ^[f??^jǫy?m??@A?a??^??^L0??h?^O??i^?
> 
> http://mid.gmane.org/CD2CABCB2C0A0D4682C5F8AD8401415409741D%40HKXPRD3002MB006.064d.mgd.msft.net
> 
> [not quite byte-for-byte identical, but very close!]
> 
> Does anyone know what the purpose of these footers is?  Highly
> compressed legal disclaimer, I'm guessing.

Paul's message in base64-encoded.

The scramble you see at the end when the message is decoded
is the majordomo signature added in plaintext, decoded as if
it were base64.

Regards,
Peter Hurley
