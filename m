Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3H0LyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:54:08 -0400
Received: from nm2-vm6.bullet.mail.gq1.yahoo.com ([98.136.218.133]:32109 "EHLO
	nm2-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3H0LyH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:54:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 609469.6589.bm@omp1095.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZULS5SeiGpom03Y775tqmpXMGk+LQMkZJAJAcH1qzZZDnuMYarPeGwVCj1cdy1R+uvj+NnBp805eslli02ryHwmLGyzsUJTLy+S25a1iCaL2DXHcz5S9Elgd/Z8xgWaZlfriw4WQNC7yhV6saZS2riOHybqtuC4CXYO+2uvGIU8=;
X-YMail-OSG: aAhqY30VM1nD0zViAmLwuvee7KOyxxnOJdS5g3QmEF_vNcC
 RuPZH3D2Xm8uxtSReWxEus19FiWbUmgoGeanPCCNliKsUvKFk2YhAILkW.DH
 vEqWS5y8FOALuIfi0XomFDXZ7x9LHywdKx2spcLz3QCtmrgrATf6plGCrleH
 RK36ba4N9C0r2uVRY5jCoyOFOYAQlVSutDCC2fqUfp2Cs5nqJsgYYvA9ztA_
 16.wvPTUbKXKfTXbF4LAmE3dauFK_aiwLQuYk8tLGl_LtzqWiK.1u0u_Eup0
 5zB0BDMb.Zhwxk2tNWYWCjfQ9xa25Vp3PsdjYeE1N4JzGeRPfHUW4O9dqtHk
 uRTBFV_Cp.HG0hfH6PWU4EJWwi9sMqaZ20RcM6WZ7R.AxA9fB5qcd61NKRTH
 WWBQdykC.STVWu4U5Wh_rNhiZGTLJhHQOoDoTtMdupkFE10CGucvzfjYZlGZ
 THjPkNs2YibX1mKlbsw.iSHlc42WwofjZ.Jy10NDE.s18j6BGcSDQD1q_bMf
 oq016VTKRPhYg6DNSFN150RYwbtqXTJbSLcDbOO5on_OJl9s5sGUeE9G4Xi.
 ErVsdNE63k2TbwkIiGNJHCw--
X-Rocket-MIMEInfo: 002.001,T2gsIFRoYW5rcyBhbG90LCBpdCB3b3JrZWQgYXMgZGVzaXJlZC4uLi4uCgpUaGFua3MuCgoKCgotLS0tLSBPcmlnaW5hbCBNZXNzYWdlIC0tLS0tCkZyb206IE1hdHMgTGlsamVncmVuIDxsaWxqZWdyZW4ubWF0czJAZ21haWwuY29tPgpUbzogU3VraSBCdXJ5YW5pIDxzdWtpYnVyeWFuaUB5YWhvby5jb20.CkNjOiAibGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZyIgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc.ClNlbnQ6IE1vbmRheSwgQXVndXN0IDI2LCAyMDEzIDY6NTUgUE0KU3ViamVjdDogUmUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.155.576
References: <1377519801.80692.YahooMailNeo@web163906.mail.gq1.yahoo.com> <CA+xJJ18+z1hiNByNQPZ8Xm+wcSLrnnYn4x4OFu+_NkSKq7oR5Q@mail.gmail.com>
Message-ID: <1377604445.95116.YahooMailNeo@web163906.mail.gq1.yahoo.com>
Date: Tue, 27 Aug 2013 04:54:05 -0700 (PDT)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: Re: how to make a option in menuconfig as new feature
To: Mats Liljegren <liljegren.mats2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+xJJ18+z1hiNByNQPZ8Xm+wcSLrnnYn4x4OFu+_NkSKq7oR5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, Thanks alot, it worked as desired.....

Thanks.




----- Original Message -----
From: Mats Liljegren <liljegren.mats2@gmail.com>
To: Suki Buryani <sukiburyani@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Monday, August 26, 2013 6:55 PM
Subject: Re: how to make a option in menuconfig as new feature

On Mon, Aug 26, 2013 at 2:23 PM, Suki Buryani <sukiburyani@yahoo.com> wrote:
> Hi,
>
> I want to add up a kernel module to my linux
> kernel,currently i am mannuly changing .config file to include my new
> module but i want to add it as option in menuconfig from where i choose
> it where it should be included or not...

I think the answer to your question lies in those Kconfig files. Find
a name of some simple driver and check how that driver is defined in
Kconfig. Check Documentation/kbuild/kconfig-language.txt for more
information about these Kconfig files.

Regards
Mats Liljegren
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

