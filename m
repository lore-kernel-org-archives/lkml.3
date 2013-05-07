Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab3EGVHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:07:31 -0400
Received: from nm13-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.79]:20532 "HELO
	nm13-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753119Ab3EGVHa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:07:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 288657.19807.bm@omp1049.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pm+LON8eCYdj7SeMElO2nl1FgjefmhWX2K9RUH3XJvH56rrsxnrkZ3Q4KGCGa4HHGszTTTz8fVKXiGF98RonxRFrQl3J1W7lLjVo3ijKBsb9kKkcQUtn+cgiPTFbdIjNsg9Ok3FSR8c2azXshee3weAb24wySY1HTIPHnwuhoWU=;
X-YMail-OSG: gykLOgUVM1mwFEXd5HHBZqAXEVBDsYbW3NQHFiJ4CKhTyLG
 N7_Hx3gig3TierUe3QG7VZbm8eY2obLXBygYOGtkHIfbU94fAnqmC9IjFpFP
 kzQZwsVo1SmIMlzH4yqqsKtslPntVvNXhCbdSCPsJXe0cCDjqhmS2rH5Skvb
 098TljR3pZ8Z5KiHqucNtbS8u.x5ysNB0YJeO3NsKJ3LpgyHt16vBz2ZRmhs
 y2Sp7MMg0au_FV8VFABXp7Gr4TGLj1I9uxvTurt7Ax33HaWID2aNRnqOlhCe
 M9qOvTSF.eKNzHy4OhkLGKu9wfrgNnX7JuJz3AXuX_mcKGXkeRFmGi4zY_Be
 7avHPRSxFjFV1s_JBFZIfJJ2jw_7gIlL6hJsf40kMOzJtxue1FJBA4IXN1hd
 6QpbS8rQAlt4791LSvsoHAmQq6TtE_celmfwArxe0WIzf5bamJcPuKu2CrBN
 RVrxz4J79kzqfPGp16CvCjSJpROjPycI8O04PMb2_oS1enOwA_fL8N9kNipv
 GONPMyekrEV_vcTYSZ4KCPQ6GLGzIM8FHXAMcHuB1PC9NBjbTFgTISYfIllQ
 omKYNFegQSFshdhYWHepNwsw56KPgtN7yrDtyH2FMwxiuHWhrw13xh1QFQgV
 X0t6BPDWR9UditP3wuArnjVQfN.dF1hXL
X-Rocket-MIMEInfo: 002.001,CgoKCi0tLS0tIE9yaWdpbmFsIE1lc3NhZ2UgLS0tLS0KPiBGcm9tOiBCam9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgo.IFRvOiBKb2huIDxkYV9hdWRpb3BoaWxlQHlhaG9vLmNvbT4KPiBDYzogbGttbCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IEplZmYgS2lyc2hlciA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29tPjsgImUxMDAwLWRldmVsQGxpc3RzLnNvdXJjZWZvcmdlLm5ldCIgPGUxMDAwLWRldmVsQGxpc3RzLnNvdXJjZWZvcmdlLm5ldD4KPiBTZW50OiBNb25kYXksIE0BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.141.536
References: <1367700969.8582.YahooMailNeo@web140004.mail.bf1.yahoo.com> <CAErSpo4C3-WH6_GOnmz1TgKsD3SyNGQYeU8Cj0=_+c+9K2yS+A@mail.gmail.com> 
Message-ID: <1367960849.23964.YahooMailNeo@web140002.mail.bf1.yahoo.com>
Date: Tue, 7 May 2013 14:07:29 -0700 (PDT)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: 3.9.0 dmesg reports that my NIC is hanging
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
> From: Bjorn Helgaas <bhelgaas@google.com>
> To: John <da_audiophile@yahoo.com>
> Cc: lkml <linux-kernel@vger.kernel.org>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>; "e1000-devel@lists.sourceforge.net" <e1000-devel@lists.sourceforge.net>
> Sent: Monday, May 6, 2013 1:29 PM
> Subject: Re: 3.9.0 dmesg reports that my NIC is hanging
> 
> [+cc Jeff, e1000-devel (from MAINTAINERS)]
> 
> On Sat, May 4, 2013 at 1:56 PM, John <da_audiophile@yahoo.com> wrote:
>>  After upgrading to the official Arch Linux 3.9-2 kernel package, dmesg 
> reports that my NIC is hanging:
>> 
>>  [    5.955720] e1000e 0000:00:19.0 eno1: changing MTU from 1500 to 4000
>>  [    8.464507] e1000e 0000:00:19.0 eno1: Detected Hardware Unit Hang:
>>    TDH                  <0>
>>    TDT                  <2>
>>    next_to_use          <2>
>>    next_to_clean        <0>
>>  buffer_info[next_to_clean]:
>>    time_stamp           <fffea787>
>>    next_to_watch        <0>
>>    jiffies              <fffeaa30>
>>    next_to_watch.status <0>
>>  MAC Status             <40080080>
>>  PHY Status             <7949>
>>  PHY 1000BASE-T Status  <0>
>>  PHY Extended Status    <3000>
>>  PCI Status             <10>
>> 
>>  Not too sure what else to post.  I am not subscribed to lkml so please cc 
> my email in your reply.
>> 
>> 
>>  Link to complete dmesg: http://pastebin.com/zRBajGrY
>>  Seems similar to: bugzilla.redhat.com/show_bug.cgi?id=785806
> 
> It sounds like this is a regression, so it might be useful to know
> what the newest working kernel was, and maybe a dmesg log from it as
> well, though I don't see any obvious clues in the 3.9.0-2-ARCH dmesg
> you collected.
> 
> Bjorn


Thank you for the reply, Bjorn.  3.8.11-1-ARCH works just fine for me.  Here is the dmesg from 3.8.11-1-ARCH per your request: http://pastebin.com/cUHwrQfq
