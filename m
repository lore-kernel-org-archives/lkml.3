Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab3G2RcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:32:07 -0400
Received: from smtprelay0046.b.hostedemail.com ([64.98.42.46]:58121 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758325Ab3G2RcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:32:03 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::,RULES_HIT:152:355:379:582:599:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2731:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:5007:6261:7903:8599:9025:10004:10400:10848:11658:11914:12043:12517:12519:12555:12698:12737:12740:12926:13025:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rod00_10f1a9661b13a
X-Filterd-Recvd-Size: 1711
Date: Mon, 29 Jul 2013 17:31:56 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: rick.jones2@hp.com
Cc: stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <144572220.42656.1375119116406.JavaMail.mail@webmail09>
References: <2066879158.39771.1375110634453.JavaMail.mail@webmail09><20130729083519.5d574f16@nehalam.linuxnetplumber.net>
 <2063167407.40450.1375112877907.JavaMail.mail@webmail09><51F6A5E2.5050100@hp.com>
Subject: Re: A call to revise sockets behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.189.148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jul 29, 2013 11:27:00 PM, rick wrote:

>> A wine developer clearly showed that this option simply doesn't work.
>>
>> http://bugs.winehq.org/show_bug.cgi?id=26031#c21
>>
>> Output of strace:
>> getsockopt(24, SOL_SOCKET, SO_REUSEADDR, [0], [4]) = 0
>> setsockopt(24, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>> bind(24, {sa_family=AF_INET, sin_port=htons(43012), sin_addr=inet_addr("0.
>> 0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)
>
>The output of netstat -an didn't by any chance happen to still show an 
>endpoint in the LISTEN state for that port number did it?
>
>rick jones
>


By chance - no, nothing is/was listening. You can recreate this test in an order of few
minutes without ever trusting my word.
