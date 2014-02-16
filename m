Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBPCQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 21:16:50 -0500
Received: from nm35-vm3.bullet.mail.bf1.yahoo.com ([72.30.238.75]:21220 "EHLO
	nm35-vm3.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbaBPCQs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 21:16:48 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Feb 2014 21:16:48 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 981507.48103.bm@omp1031.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=g/1uH4RqCENFrNFINN8vhgVOROqREAIlDbkAhTebdOxvNV6PehlZ3B6mG/yQqEw2p81g95SwyOZ/fFthC5Ep1l/2ckad+Tsj6tazyZ4d/z/eoXT2OhMnFF3JlAvz5Qq5GA2qeOKMAyr5djpGrdesc5wk9FFXsN5xJzMMdxuXXYI=;
X-YMail-OSG: VGuNTJgVM1nE.tn7wGz2xIfZGvqA.aYIjiOelhd6taTb2Jz
 5P_tAh1YlzqohjBN9Mjfx53uj.TVTCImxZVMHTg0PT1d3wYLS3DgMGpDRxbH
 AxiEF0Z2lc5W_5QQmg2I1rzTs_4Vbyy.E1B3NmW1CYBJHsNTd0UU72OKU1TW
 k_ZZYZfBtA44hYw0.L99glNoONLTd.nDZUBvn.cI00CDsiImezFfLtcfX8NB
 _OXRnUOPsbXi_ZWG1DlI5ITnfO.i6DMtrxze73A8pwnpnqlEEXSwNo6UKmxI
 dY_pLhZB4Dh8yPKtUelccBxqnCFFhHR7r29np8tzGlrTukU5.NgzxEU9xAEY
 Akv1pMoUhEj00XXD5BEHLoWK1WFBF9q.MeVUgaZhXfLIf69kG8woojezrG4L
 Mf4sJuFDXww_GJZ1kFaYs1iXVJx9vV0wsIJ2RR3W7E9CTJyYCKKdfsvrOGGZ
 K8X8iJRzqnwdyoD8jPH_v0cSEOlfD9cyjuiqplN9ZAxlBVxN6c6rssWB7Lqy
 e85.hLWc9OPvN6jmH4lRwgi6vHxSvssllU2ipUrZ0jqX9JhYl5RPIKIWbkrG
 .WTXCjLuNzoD34D7HigrCTxX8HVRvexbJ91_sjGc3Eo9vjOENuyi32RlTS1S
 OpAzreHITuK3PxLi_kvsov1aYPXH.pxlMHHLwqGmFvsOFVt6jL_qvylcUhy0
 jquh4QTxRm.jowJk533eMBRMc4wUvrvr3ki3HFGYPqpYZ4TxD9QihzQq3VmX
 wMtQ1XTLDFoL3hZHb0uyAakrlj7K5qRUq2ANc050s8QVG9l2TCQbLYn_74eA
 h52iWzA2BKBtdpYiHqEP.3gGGSg2_2ySXqHXWrU16JXZyj74EISiy8MWszGw
 y_Fnv27xELtfgZa3nj_6f_jYdikQ3cZOe3Ctmp.8-
X-Rocket-MIMEInfo: 002.001,CgoKCi0tLS0tIE9yaWdpbmFsIE1lc3NhZ2UgLS0tLS0KPiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgPD4KPiBTZW50OiBTYXR1cmRheSwgRmVicnVhcnkgMTUsIDIwMTQgNjoyNSBQTQo.IFN1YmplY3Q6IFJlOiBbQlVHXSB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UKPiAKPiBPbiBTYXQsIEZlYiAxNSwgMjAxNCBhdCAwMTowNDoyMlBNIC0wODAwLCBKb2huIHdyb3RlOgo.PiAgVGhhbmtzIGZvciB0aGUgcmVwbHksIEJvcmlzLiDCoFRoZSAuY29uZmlnIGlzIHVubW9kaWYBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392466251.41282.YahooMailNeo@web140003.mail.bf1.yahoo.com> <1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com> <20140215203015.GA4528@pd.tnic> <1392498262.98385.YahooMailNeo@web140003.mail.bf1.yahoo.com> <20140215232508.GB4508@pd.tnic>
Message-ID: <1392516586.24492.YahooMailNeo@web140006.mail.bf1.yahoo.com>
Date: Sat, 15 Feb 2014 18:09:46 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mlindner@marvell.com" <mlindner@marvell.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20140215232508.GB4508@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
> From: Borislav Petkov <>
> Sent: Saturday, February 15, 2014 6:25 PM
> Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
> 
> On Sat, Feb 15, 2014 at 01:04:22PM -0800, John wrote:
>>  Thanks for the reply, Boris.  The .config is unmodified
>>  from the Arch Distro default for 3.13.3-1 which can be found
>>  here: http://pastebin.com/LPGZ8ZqA
> 
> Yep, it is that struct net *net argument to put_pipe_version() which is NULL:
> 
>   12:   55                      push   %ebp
>   13:   89 e5                   mov    %esp,%ebp
>   15:   56                      push   %esi
>   16:   53                      push   %ebx
>   17:   3e 8d 74 26 00          lea    %ds:0x0(%esi,%eiz,1),%esi
>   1c:   8b 1d 28 e9 a3 f8       mov    0xf8a3e928,%ebx
>   22:   89 c6                   mov    %eax,%esi
>   24:   e8 59 64 5f c8          call   0xc85f6482
>   29:   85 db                   test   %ebx,%ebx
>   2b:*  8b 86 58 08 00 00       mov    0x858(%esi),%eax         <-- trapping 
> instruction
> 
> put_pipe_version:
>     pushl    %ebp    #
>     movl    %esp, %ebp    #,
>     pushl    %esi    #
>     pushl    %ebx    #
>     call    mcount
>     movl    sunrpc_net_id, %ebx    # sunrpc_net_id, sunrpc_net_id.130
>     movl    %eax, %esi    # net, net
>     call    __rcu_read_lock    #
>     testl    %ebx, %ebx    # sunrpc_net_id.130
>     movl    2136(%esi), %eax    # MEM[(struct net_generic * const *)net_4(D) + 
> 2136B], ng <-- trapping insn
> 
> 
>     [ 137.689996] ESI: 00000000 EDI: f56efc00 EBP: f568fee8 ESP: f568fee0
>                ^^^^^^^^
> 
> Here's the c/asm interleaved version:
> 
> static void put_pipe_version(struct net *net)
> {
>      d80:       55                      push   %ebp
>      d81:       89 e5                   mov    %esp,%ebp
>      d83:       56                      push   %esi
>      d84:       53                      push   %ebx
>      d85:       e8 fc ff ff ff          call   d86 <put_pipe_version+0x6>
>                         d86: R_386_PC32 mcount
>         struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
>      d8a:       8b 1d 00 00 00 00       mov    0x0,%ebx
>                         d8c: R_386_32   sunrpc_net_id
>         spin_unlock(&pipe_version_lock);
>         return ret;
> }
> 
> static void put_pipe_version(struct net *net)
> {
>      d90:       89 c6                   mov    %eax,%esi
> * block, but only when acquiring spinlocks that are subject to priority
> * inheritance.
> */
> static inline void rcu_read_lock(void)
> {
>         __rcu_read_lock();
>      d92:       e8 fc ff ff ff          call   d93 <put_pipe_version+0x13>
>                         d93: R_386_PC32 __rcu_read_lock
>         struct net_generic *ng;
>         void *ptr;
> 
>         rcu_read_lock();
>         ng = rcu_dereference(net->gen);
>         BUG_ON(id == 0 || id > ng->len);
>      d97:       85 db                   test   %ebx,%ebx
> {
>         struct net_generic *ng;
>         void *ptr;
> 
>         rcu_read_lock();
>         ng = rcu_dereference(net->gen);
>      d99:       8b 86 58 08 00 00       mov    0x858(%esi),%eax            
> <-- trapping insn
> 
> 
> I guess you could avoid the crash if you did
> 
>     if (!net)
>         return;
> 
> in put_pipe_version() but this hardly is the right solution. Someone
> else has to make sense of this thing, not me. :-)
> 
> HTH.


I copy someone you cc'ed on this understands it.  I have no idea what you wrote :)
