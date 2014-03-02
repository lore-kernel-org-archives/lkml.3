Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaCBASN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 19:18:13 -0500
Received: from nm15-vm5.bullet.mail.gq1.yahoo.com ([98.137.176.77]:44179 "EHLO
	nm15-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbaCBASL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 19:18:11 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2014 19:18:11 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 791773.83788.bm@omp1018.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=I4ymvyU8NWT979sxIltsawmlsEOIMCmID6wMAoSFl2Ym/Q2zwFBfTQcCq0Fj8aXFyaLpNt5Z92yaNgeNHrHcACd9D1b+cJSGbEgv4CdlO3Jh5OGEzcIN7+wP1T4G/2RgACsBXPBkl2iMpvow+H68A4yT4xveLMwhj/FbAenFUvc=;
X-YMail-OSG: eCkrlfcVM1nOYQ.Clu.EJibB58yERG5OQgUopHNhSbvYiSd
 pyjfuqvJgAKh.gVoA0XDh8Fn0H9xkx7ctn4.yl_UVh4MrorocI6S6c_LSEzz
 IvDVoY8zrTt3v_HiGWRxR4Px5yhUwI4e6hAUlSM87IWssCK6rI0dT28rJzYZ
 tUDzyJsmt0KYF1Nsk3d9TrQ9uJuCRIdAmyKWL2yMNi7F0yn2XBSaQWhnN_9y
 CZl9d4LglIrjlJZC_VsI.R8TEm27XifXwBYs_sF1BBECGayyUoJMcYm.9alv
 .PwxwTVqACq1qXDI32Y7jArr4olqpY_xpYeuDKS1oNVaTC5Xa9B9eSj_iZok
 qZh7iigiUG2OlUk1zTzsRK9hy0KcjB2FPof73GJoCMI7c7IwH0JdtNsehlfx
 uaOuvVMoL_bszrrPSs06EnNoFvFcZqs6.nCMK4A27lE04S1MHR7ggSuLepAi
 9ewwMMfitbG1YVYBauuFhxdiwEuAMJieHs9r4kQY.MDUrc8MCWU.TjpqNLiR
 4zhrX64dzpIZ6g.vU16As.DUUP27L8MA-
X-Rocket-MIMEInfo: 002.001,SGkgRGFuLAoKCj5PbiBTYXR1cmRheSwgTWFyY2ggMSwgMjAxNCA2OjQ2IEFNLCBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20.IHdyb3RlOgo.Pk9uIFNhdCwgTWFyIDAxLCAyMDE0IGF0IDA0OjI4OjI3QU0gLTA2MDAsIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj4gVGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGEgaGFuZGZ1bCBvZiBvdXRsIGFuZCBpbmwgaGVscGVyIGZ1bmN0aW9ucyB3aXRoIHRoZQo.PiB1bHRpbWF0ZSBnb2FsIG9mIGltcHJvdmluZyBjb2RlIHJlYWRhYmlsaXR5IGFuZCABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com> <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com> <20140301124418.GT26776@mwanda>
Message-ID: <1393719127.24160.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Sat, 1 Mar 2014 16:12:07 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 1/2] Staging: comedi: introduce outl_1564_* and inl_1564_* helper functions in hwdrv_apci1564.c
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140301124418.GT26776@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,


>On Saturday, March 1, 2014 6:46 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>On Sat, Mar 01, 2014 at 04:28:27AM -0600, Chase Southwood wrote:
>> This patch introduces a handful of outl and inl helper functions with the
>> ultimate goal of improving code readability and allowing several lines
>> which violate the character limit to be shortened in a sane way.
>> 
>> Cc: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> This patchset serves as a replacement to my previous cleanup patchset for
>> hwdrv_apci1564.c
>> 
>> Dan,
>> After spending a little bit more time with this and trying out different
>> ways of cleaning this up, I decided that making helper functions for all
>> of the most common register sets would look the best, but I haven't made
>> a helper for a few of the least common inl/outl calls because if I did,
>> the sheer number of helper functions would get quite ridiculous.
>> Let me know if you think my selections of what to make into helper
>> functions seems appropriate.
>> 
>
>Yeah.  You're right...  It's kind of a lot of helper functions.
>
>I wonder if we could just do something like:
>
>static void outl_amcc(struct addi_private *devpriv, unsigned int cmd,
>              unsigned int reg)
>{
>    outl(cmd, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + reg);
>}
>
>And then change APCI1564_DIGITAL_IP_INTERRUPT_MODE1 to be:
>
>#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1 (0x4 + 0x4)
>

I like this idea.  Just to clarify though, basically all of the macros would
change to something like 

#define APCI1564_DIGITAL_IP 0x4 #define APCI1564_DIGITAL_IP_INTERRUPT_MODE1 (0x4 + 0x4) #define APCI1564_DIGITAL_IP_INTERRUPT_MODE2		 (0x4 + 0x8) #define APCI1564_DIGITAL_IP_IRQ (0x4 + 0x10) #define APCI1564_DIGITAL_OP 0x18 #define APCI1564_DIGITAL_OP_RW 0x18 #define APCI1564_DIGITAL_OP_INTERRUPT (0x18 + 0x4) #define APCI1564_DIGITAL_OP_IRQ (0x18 + 0xc)
etc... and then we just have the single helper function
(the corrected version from your follow up email) and then
the calls would be something to the effect of:

outl_amcc(devpriv, cmd, APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
or whichever macro is appropriate?  It definitely trims down
the length of the function calls by removing the dereference of
devpriv and the addition to get the proper register...I like that.

>
>The only problem with that would be i_APCI1564_Reset().  Is
>i_APCI1564_Reset() buggy?  Ian or Hartley might know.  Take a look at
>other comedi drivers as well to see what they do.
>

I agree.  I'll look into the other addi-data drivers (the layout of each
appears pretty similar) or see if Ian or Hartley can shed more light on the
reset function, because I have a sneaking suspicion that a good few of the lines
in it already are buggy, and it seems like there's a chance that it's not clearing
all of the registers that it should be, either.  I could be wrong about that though.

At any rate, I'll see what I can do.

Thanks,
Chase

>
>regards,
>
>dan carpenter

