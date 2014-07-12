Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaGLDOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 23:14:00 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63987 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaGLDN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 23:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <1404798135.16156.50.camel@pasglop>
References: <CAPDOMVi5ptjaKzT+Exd3XtKcy7W7nNZYUD+MEwN8LmhPrQTZBQ@mail.gmail.com>
	<53BB6067.1090402@roeck-us.net>
	<CAPDOMVgeUWGtMC2yssh3zz6y208mHW5WCduDCwr+J09d7LF+CQ@mail.gmail.com>
	<53BB6C2D.60209@roeck-us.net>
	<CAPDOMVj0LPN1+wb-vj4ruruz4bpQb4X5nvRVtNWMpQecVgmd6A@mail.gmail.com>
	<1404798135.16156.50.camel@pasglop>
Date: Fri, 11 Jul 2014 23:13:58 -0400
Message-ID: <CAPDOMVggm6mPrNS1KO1KksntMaYL6cvUB1_rHpF91akn5amvpg@mail.gmail.com>
Subject: Re: Fwd: Fwd: Allyesconfig for powerpc still Failing
From: Nick Krause <xerofoify@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc: paulus@samba.org, mahesh <mahesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        svaidy <svaidy@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec547ccdbe6f7c004fdf672d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec547ccdbe6f7c004fdf672d7
Content-Type: text/plain; charset=UTF-8

>> > Guenter Roeck wrote on Mon, Jul 7, 2014 at 11:07 PM
>> > I submitted a patch to work around this problem a couple of weeks ago [1].
>> > Unfortunately, with this patch applied, allyesconfig still fails with
>> > relocation errors, but at least the above message is gone, and
>> > allmodconfig passes.
>> >
>> > Maybe we can convince Ben to accept the patch ...
>> >
>> > Thanks,
>> > Guenter
>> >
>> > ---
>> > [1] https://lkml.org/lkml/2014/6/30/607
>> >
>> > Hey Guenter,
>> > Would you mind sending me the patch that fixes these errors.
>> > I would like to test it before sending in to Ben.
>> > Cheers Nick
>> >
>>
>> Hi Nick,
>>
>> Just follow the link above, select 'forward', and follow the directions.
>> You'll get the patch per e-mail.
>>
>> Alternative:
>>
>> wget "http://download.gmane.org/gmane.linux.kernel/1736036/1736037"
>>
>> The patch will be in a file named '1736037'.
>>
>> I copied the list for others, in case the 'how to download a patch'
>> question comes up again.
>>
>> Guenter
>>
>> Guenter,
>> Your patch works for me in building the powerpc allyesconfig.
>> This is one news, I am going to send this patch to Ben.
>> Cheers Nick
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>

Powerpc allyesconfig seems to be succeeding as of me pulling upstream
today. On the other hand I get one
randconfig build to succeed and the second fails. I will attach my log
of the failing build.
Cheers Nick

--bcaec547ccdbe6f7c004fdf672d7
Content-Type: application/octet-stream; name=randconfig2
Content-Disposition: attachment; filename=randconfig2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxiczetz0

d2FybmluZzogKFVTQl9PVEdfRlNNICYmIEZTTF9VU0IyX09URyAmJiBVU0JfTVZfT1RHKSBzZWxl
Y3RzIFVTQl9PVEcgd2hpY2ggaGFzIHVubWV0IGRpcmVjdCBkZXBlbmRlbmNpZXMgKFVTQl9TVVBQ
T1JUICYmIFVTQiAmJiBQTV9SVU5USU1FKQp3YXJuaW5nOiAoTVBDODM2eF9SREsgJiYgTVREX05B
TkRfRlNMX0VMQkMgJiYgTVREX05BTkRfRlNMX1VQTSkgc2VsZWN0cyBGU0xfTEJDIHdoaWNoIGhh
cyB1bm1ldCBkaXJlY3QgZGVwZW5kZW5jaWVzIChGU0xfU09DKQp3YXJuaW5nOiAoVVNCX09UR19G
U00gJiYgRlNMX1VTQjJfT1RHICYmIFVTQl9NVl9PVEcpIHNlbGVjdHMgVVNCX09URyB3aGljaCBo
YXMgdW5tZXQgZGlyZWN0IGRlcGVuZGVuY2llcyAoVVNCX1NVUFBPUlQgJiYgVVNCICYmIFBNX1JV
TlRJTUUpCndhcm5pbmc6IChNUEM4MzZ4X1JESyAmJiBNVERfTkFORF9GU0xfRUxCQyAmJiBNVERf
TkFORF9GU0xfVVBNKSBzZWxlY3RzIEZTTF9MQkMgd2hpY2ggaGFzIHVubWV0IGRpcmVjdCBkZXBl
bmRlbmNpZXMgKEZTTF9TT0MpCnBvd2VycGM2NC1saW51eC1nbnUtbGQ6IHVucmVjb2duaXNlZCBl
bXVsYXRpb24gbW9kZTogZWxmNjRscHBjClN1cHBvcnRlZCBlbXVsYXRpb25zOiBlbGY2NHBwYyBl
bGYzMnBwY2xpbnV4IGVsZjMycHBjIGVsZjMycHBjc2ltCm1ha2VbMV06ICoqKiBbdXNyL2J1aWx0
LWluLm9dIEVycm9yIDEKbWFrZTogKioqIFt1c3JdIEVycm9yIDIKbWFrZTogKioqIFdhaXRpbmcg
Zm9yIHVuZmluaXNoZWQgam9icy4uLi4KcG93ZXJwYzY0LWxpbnV4LWdudS1sZDogdW5yZWNvZ25p
c2VkIGVtdWxhdGlvbiBtb2RlOiBlbGY2NGxwcGMKU3VwcG9ydGVkIGVtdWxhdGlvbnM6IGVsZjY0
cHBjIGVsZjMycHBjbGludXggZWxmMzJwcGMgZWxmMzJwcGNzaW0KbWFrZVsxXTogKioqIFtpbml0
L21vdW50cy5vXSBFcnJvciAxCm1ha2VbMV06ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpv
YnMuLi4uCm1ha2U6ICoqKiBbaW5pdF0gRXJyb3IgMgovdXNyL2xpYi9nY2MvcG93ZXJwYzY0LWxp
bnV4LWdudS80LjguMS8uLi8uLi8uLi8uLi9wb3dlcnBjNjQtbGludXgtZ251L2Jpbi9sZDogdW5y
ZWNvZ25pc2VkIGVtdWxhdGlvbiBtb2RlOiBlbGYzMmxwcGNsaW51eApTdXBwb3J0ZWQgZW11bGF0
aW9uczogZWxmNjRwcGMgZWxmMzJwcGNsaW51eCBlbGYzMnBwYyBlbGYzMnBwY3NpbQpjb2xsZWN0
MjogZXJyb3I6IGxkIHJldHVybmVkIDEgZXhpdCBzdGF0dXMKbWFrZVsyXTogKioqIFthcmNoL3Bv
d2VycGMva2VybmVsL3Zkc28zMi92ZHNvMzIuc28uZGJnXSBFcnJvciAxCm1ha2VbMV06ICoqKiBb
YXJjaC9wb3dlcnBjL2tlcm5lbC92ZHNvMzJdIEVycm9yIDIKbWFrZVsxXTogKioqIFdhaXRpbmcg
Zm9yIHVuZmluaXNoZWQgam9icy4uLi4KcG93ZXJwYzY0LWxpbnV4LWdudS1sZDogdW5yZWNvZ25p
c2VkIGVtdWxhdGlvbiBtb2RlOiBlbGY2NGxwcGMKU3VwcG9ydGVkIGVtdWxhdGlvbnM6IGVsZjY0
cHBjIGVsZjMycHBjbGludXggZWxmMzJwcGMgZWxmMzJwcGNzaW0KbWFrZVsxXTogKioqIFthcmNo
L3Bvd2VycGMvbW0vYnVpbHQtaW4ub10gRXJyb3IgMQptYWtlOiAqKiogW2FyY2gvcG93ZXJwYy9t
bV0gRXJyb3IgMgovdXNyL2xpYi9nY2MvcG93ZXJwYzY0LWxpbnV4LWdudS80LjguMS8uLi8uLi8u
Li8uLi9wb3dlcnBjNjQtbGludXgtZ251L2Jpbi9sZDogdW5yZWNvZ25pc2VkIGVtdWxhdGlvbiBt
b2RlOiBlbGY2NGxwcGMKU3VwcG9ydGVkIGVtdWxhdGlvbnM6IGVsZjY0cHBjIGVsZjMycHBjbGlu
dXggZWxmMzJwcGMgZWxmMzJwcGNzaW0KY29sbGVjdDI6IGVycm9yOiBsZCByZXR1cm5lZCAxIGV4
aXQgc3RhdHVzCm1ha2VbMl06ICoqKiBbYXJjaC9wb3dlcnBjL2tlcm5lbC92ZHNvNjQvdmRzbzY0
LnNvLmRiZ10gRXJyb3IgMQptYWtlWzFdOiAqKiogW2FyY2gvcG93ZXJwYy9rZXJuZWwvdmRzbzY0
XSBFcnJvciAyCm1ha2U6ICoqKiBbYXJjaC9wb3dlcnBjL2tlcm5lbF0gRXJyb3IgMgptYWtlOiAq
Kiogd2FpdDogTm8gY2hpbGQgcHJvY2Vzc2VzLiAgU3RvcC4K
--bcaec547ccdbe6f7c004fdf672d7--
