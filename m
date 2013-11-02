Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3KBTp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 15:45:58 -0400
Received: from smtp106.biz.mail.gq1.yahoo.com ([98.137.12.181]:48829 "HELO
	smtp106.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752775Ab3KBTpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 15:45:54 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Nov 2013 15:45:54 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ye9mUuYVM1ll38SG.HZ2oQEPYLy9HsUPz64db118x9vX83Z
 vY3fBcFy0EEBF4lHkAVKkM9Ky4Y2irSfEwEf8G1rScj4if5w4XEmg7k1J4rF
 oLjv35oZt0xs6NqOZHviHKZzhr0j0XX4z2drKPEsl1rj_n3iEXAGnFQCrHfO
 gX3EZwcXPUAxXG8dsRmYinPFhCIMRqBRC5z6n9jCen7xjj8qgUu1VBAW0IYP
 pE0LH_jMWmWeVODHKtBIPSgzrtTUZ2I3RryQirBCOMx1jAcOVmBizvvF.dPG
 r48_mChqLAd04gpEH53Cjaw4FY3vqQZxH3rbtWhJwyfadaXKdZfe2ymiLTmz
 _ezUg6TW92nrWk4zs.oUXOeTR97leShLFnIpM9mrzD0KSu1t0OGvhjeFRZq4
 ogm59Rq_XzzUGfbJbYqODivnygDLIEp0sMfNlYFrIzQZievVX1BOIAzVRWSJ
 A3SGM46wMbBW7dv0J0m_2sHseGUKAX_y_tqAKxzvP.WzXHCU8Zh9RiCeRqQo
 tZVH2DWaLJoo7M4.xOEXFtLrVuY1mPGlozJgxNRmwE2lO
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@67.180.103.242 with )
        by smtp106.biz.mail.gq1.yahoo.com with SMTP; 02 Nov 2013 19:39:13 +0000 UTC
Message-ID: <527554E2.4080806@schaufler-ca.com>
Date: Sat, 02 Nov 2013 12:39:14 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        james.l.morris@oracle.com, jmorris@namei.org, keescook@chromium.org
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
References: <20131016151831.GE5186@outflux.net>	<201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp>	<525F083D.8060502@schaufler-ca.com>	<CAGXu5jLSDynZ_XRZGZ+0uZTgtygO1n8+3rOnR+WonH5-tkui6A@mail.gmail.com>	<201310170037.r9H0b6jT024903@www262.sakura.ne.jp> <201310262251.IFB56202.HSFOOtFMVOFLQJ@I-love.SAKURA.ne.jp>
In-Reply-To: <201310262251.IFB56202.HSFOOtFMVOFLQJ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2013 6:51 AM, Tetsuo Handa wrote:
> Tetsuo Handa wrote:
>> I would send another one which uses only security_file_alloc/free .
> I sent it to James, Casey and Kees on "Fri, 18 Oct 2013 22:56:19 +0900" and
> waiting for your response. How long are we expected to remain vulnerable due to
> lack of multiple concurrent LSM support?

Having just spent a good chunk of the past year on the technical
issues, and having participated in the LSM development process since
its inception, I'd say there's at least a year before the dust settles.
Having a wad of code that works is one thing. Breaking it into chunks
that are both useful and small enough for the community to swallow is
another. Transforming a collection of clever hacks into an infrastructure
is a third. Once that's done we can deal with the naysayers.

Fortunately, we have a wad of code that works. Nobody seems to
think that taking that code as is is a great idea. Nobody has
this as their first priority, either. We're making progress, but
we know we need to be careful. I seriously doubt we'll get more
than one shot at it.

