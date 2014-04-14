Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaDNCVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 22:21:19 -0400
Received: from nm21-vm2.bullet.mail.ir2.yahoo.com ([212.82.96.253]:27925 "EHLO
	nm21-vm2.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbaDNCVQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 22:21:16 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Apr 2014 22:21:16 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 817116.41357.bm@omp1001.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pCxDgHYO53rhRMssS9N2ueCBmwU9c2gJc7bmJ/A2ZCojc6Vs5ACtcHUTu/ust/ijr5XxY1S9f4Q4EuZjyqNGK6d8Me4olDzlvLbEpZwKaNCwyqQKyJ0tp21SPb2VWVCOFwo2PmJExavAdbgwlRe2FRTNu3c2c5Mi5/CI8clGeHE=;
X-YMail-OSG: x1CgaocVM1kTBVyERIkXoWhs6BLUenmACp1H.hjU79fMj60
 zV2DYMdC0XtzfF8w3axIUNzUJmqFXkk9z7wp5W7o2cqcVH3vNKwYS9ModMc8
 8yP5IvV6GUvCd5dYQA.eQS_riukU2r4sfg.ouF1sJFpF4meqCXqyWP_sQQq0
 vSQ_UQdTv3s43WfuiRGthZXS1yJt0tV6_HWF7j7YGOkIRek21aaaK7lXYV0t
 HWl9dbXZ8.Uz028pArfObSHDSyr_jGCMT6qtl8P0fq3ZBimbUBogr0aM5wws
 h7k4tCUgnMNxk27C4KkL0U7EiVdXi.PgF.COWD.Lrr5WLSHv8aKHoMw18XYc
 8zAB_GBPvwIQjvzUNZCiBM8ozknjn8YYM_fDa8NMQnPCdq8NahXI.YX1Q1Q8
 T2BxQ5mYKebj4LN9F1W3x0.PvRYCX_1U9CO_njigX1.8hXOQNj2MZevxU4ke
 mkC4b3cIEvYevzKqSisepgP_jTtiYwkyYave3TACuKhReOovkeJ5njw.IPh.
 anKMxwsHVQtA7TYFDP97hnijuooU2zr6MIK741S7fWD9BrRGc1fGe53yx1t1
 VbSYj55fUfbydX_oyKuADdyNx1boxSjlI1Dzdnn1pCPtkdZcACc9opw--
X-Rocket-MIMEInfo: 002.001,CgpoaSBrZXJuZWwtZGV2ZWxvcGVycyBfCgpmcm9tIHJlY2VudCBjb3ZlcmFnZSBvZiB0aGUgTFNGTU0tU3VtbWl0IG9uIExXTi5uZXQsIGkgYWdhaW4gZ290IHRoZSBpbXByZXNzaW9uIHRoYXQgdGhlcmUgYXJlIHBlcmZvcm1hbmNlLSAmIGJlaGF2aW91ciAtIGlzc3VlcywgdGhhdCBwZXJzaXN0ZW50bHkgZG9uwrR0IHNlZW0gdG8gZ2V0IHJlc29sdmVkICYgc3RheSBhcm91bmQgZm9yIHRoZSBuZXh0IHN1bW1pdC4gQWRkaXRpb25hbGx5IG1hbnkgdGhpbmdzIGNvbWUgdG8gbGlnaHQgYXQgc3VjaCBtZWV0aW4BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.182.648
Message-ID: <1397441637.79653.YahooMailNeo@web173203.mail.ir2.yahoo.com>
Date: Mon, 14 Apr 2014 03:13:57 +0100 (BST)
From: Winston Graeme <wini_g_2003@yahoo.co.uk>
Reply-To: Winston Graeme <wini_g_2003@yahoo.co.uk>
Subject: is there a central index of subsystem- & cross-border - issues with progress on these  ?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



hi kernel-developers _

from recent coverage of the LSFMM-Summit on LWN.net, i again got the impression that there are performance- & behaviour - issues, that persistently don´t seem to get resolved & stay around for the next summit. Additionally many things come to light at such meetings of different user & development-sections, which often seem to get lost again, as there is no central index, page or wiki, .. of cross-border issues & progress on these . 


There are more specific mailiglists for e.g. LF - workgroups or vendor- & distributor - specific kernel - pages, -portals & -wikis, but the only thing similar to a central index, that i could find, is the LWN - kernel-page index ( http://lwn.net/Kernel/Index/ ). Documentation being a weakness of the development process, LWN might be the only place. 



Additionally there is the issue of, again undocumented, kernel features ; this all seems to me like unnecessarily hindering to coordination & progress.



or does this kind of place exist somewhere ?
please cc me as i am not subscribed - thank-you


_ vincent . 
