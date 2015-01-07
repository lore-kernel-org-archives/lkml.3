Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbbAGHee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:34:34 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63257 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbAGHec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:34:32 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20150107151618.7cb9d574@canb.auug.org.au>
References: <20150107151618.7cb9d574@canb.auug.org.au>
Date: Wed, 7 Jan 2015 08:34:30 +0100
Message-ID: <CA+icZUWr8gv3vZWdgBT7ovVxHt-kGimgzLhc4=CZLVYoAwJc3g@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 7
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bb0394645cd0d050c0af429
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bb0394645cd0d050c0af429
Content-Type: text/plain; charset=UTF-8

On Wed, Jan 7, 2015 at 5:16 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20150106:
>
> *crickets*
>
> Non-merge commits (relative to Linus' tree): 1350
>  1543 files changed, 41856 insertions(+), 24250 deletions(-)
>

Happy new year,

this release is a very special for me.
I had to apply zero null nada patches of mine or others :-).

The calm days between Xmas and new year, I started again to build and
test Linux-next (aka v3.20) kernels .

This was primarily to play with loop-mq from block-next tree.
As a sidenote I reported some bugs in fio, now we have v2.2.4.

En plus, I refreshed my build-script for -next (see attached file).
And I am really happy to see my builddeb patches in kbuild-next.

Thanks to all involved people.

Regards,
- Sedat -

> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" and checkout or reset to the new
> master.
>
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
> multi_v7_defconfig for arm. After the final fixups (if any), it is also
> built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
> allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
> defconfig.
>
> Below is a summary of the state of the merge.
>
> I am currently merging 234 trees (counting Linus' and 32 trees of patches
> pending for Linus' tree).
>
> Stats about the size of the tree over time can be seen at
> http://neuling.org/linux-next-size.html .
>
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
>
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>

--047d7bb0394645cd0d050c0af429
Content-Type: application/x-sh; name="build_linux-next.sh"
Content-Disposition: attachment; filename="build_linux-next.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4mdz4nl1

IyEvYmluL3NoCgojIyMgTEFTVCBNT0RJRklFRDogMDctSkFOLTIwMTUgKFNlZGF0IERpbGVrIDxz
ZWRhdC5kaWxla0BnbWFpbC5jb20+KQoKIyMjIEhFTFAKIyAxLiBtYWtlIGRlYi1wa2cgKG9wdGlv
bnMpOiAgPGZpbGU6IHNjcmlwdHMvcGFja2FnZS9idWlsZGRlYj4KIyAyLiBsb2NhbHZlcnNpb24g
aGFuZGxpbmc6ICAgPGZpbGU6IHNjcmlwdHMvc2V0bG9jYWx2ZXJzaW9uPgojIDMuIEtCVUlMRF9V
U0VSXyogdmFyaWFibGVzOiA8ZmlsZTogc2NyaXB0cy9ta2NvbXBpbGVfaD4KIyA0LiBQcmVyZXFz
L1ByZXBhcmF0aW9uOiAgICAgPGh0dHA6Ly9rZXJuZWwtaGFuZGJvb2suYWxpb3RoLmRlYmlhbi5v
cmcvY2gtY29tbW9uLXRhc2tzLmh0bWwjczQuMi4xPgoKIyMjIFBSRVJFUVM6IEluc3RhbGwgYnVp
bGQtZXNzZW50aWFsLCBmYWtlcm9vdCwgZHBrZy1kZXYgYW5kIGdpdCBwYWNrYWdlcwojYXB0LWdl
dCB1cGRhdGUKI2FwdC1nZXQgaW5zdGFsbCBidWlsZC1lc3NlbnRpYWwgZmFrZXJvb3QgZHBrZy1k
ZXYgZ2l0CgojIyMgTGFuZ3VhZ2Ugc2V0dGluZ3MKZXhwb3J0IExBTkc9QwpleHBvcnQgTENfQUxM
PUMKCiMjIyBCYXNlIGlzIExpbnV4LW5leHQgc291cmNlIGRpcmVjdG9yeQpCQVNFX0RJUj0kKHB3
ZCkKU1JDX0RJUj0iJHtCQVNFX0RJUn0vbGludXgtbmV4dCIKCiMjIyBDbG9uZSBMaW51eC1uZXh0
IHJlbW90ZSBHSVQgdHJlZQojR0lUX1VSTD0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L25leHQvbGludXgtbmV4dC5naXQiCiNnaXQgY2xvbmUgJHtHSVRfVVJM
fQoKIyMjIENoYW5nZSB0byBidWlsZCBkaXJlY3RvcnkKY2QgJHtTUkNfRElSfQoKIyMjIE1ha2Ug
YW5kIGNvbXBpbGVyIHNldHRpbmdzCk1BS0U9Im1ha2UiCk1BS0VfSk9CUz0kKCgkKGdldGNvbmYg
X05QUk9DRVNTT1JTX09OTE4pKzEpKQpDQ19GT1JfQlVJTEQ9ImdjYy00LjkiCgojIyMgRXh0cmFj
dCB2ZXJzaW9uLXRhZ3MgYW5kIHJlbGVhc2UtZGF0ZSBmcm9tIGxvY2FsIEdJVCB0cmVlCkxBVEVT
VF9VUFNUUkVBTV9WRVJfVEFHPSQoZ2l0IGZvci1lYWNoLXJlZiAtLXNvcnQ9dGFnZ2VyZGF0ZSAt
LWZvcm1hdD0iJShyZWZuYW1lOnNob3J0KSIgcmVmcy90YWdzIHwgZ3JlcCBeJ3ZbMC05XS5bMC05
XSonIHwgdGFpbCAtMSkKTEFURVNUX05FWFRfVkVSX1RBRz0kKGdpdCBmb3ItZWFjaC1yZWYgLS1z
b3J0PXRhZ2dlcmRhdGUgLS1mb3JtYXQ9IiUocmVmbmFtZTpzaG9ydCkiIHJlZnMvdGFncyB8IGdy
ZXAgXiduZXh0LVswLTldXHs4XH0nIHwgdGFpbCAtMSkKbmV4dF9kYXRlPSQoZWNobyAkTEFURVNU
X05FWFRfVkVSX1RBRyB8IGN1dCAtZCctJyAtZjIpCgojIyMgRGlzdHJpYnV0aW9uIHNldHRpbmdz
CiMgTk9URTogJGRpc3RyaWJ1dGlvbiBpcyB1c2VkIGluICRkZWJpYW5fcmV2aXNpb24KZGlzdHJp
YnV0aW9uPSQobHNiX3JlbGVhc2UgLS1jb2RlbmFtZSAtLXNob3J0KQoKIyMjIFVwbG9hZGVyIHNl
dHRpbmdzCiMgTk9URTogJHVwbG9hZGVyIGlzIHVzZWQgaW4gJGRlYmlhbl9yZXZpc2lvbgpleHBv
cnQgREVCRlVMTE5BTUU9IlNlZGF0IERpbGVrIgpleHBvcnQgREVCRU1BSUw9InNlZGF0LmRpbGVr
QGdtYWlsLmNvbSIKdXBsb2FkZXI9ImRpbGVrcyIKCiMjIyBEZWJpYW4gdXBzdHJlYW0gdmVyc2lv
biBzZXR0aW5ncyAKIyBOT1RFLTE6ICR1cHN0cmVhbV92ZXJzaW9uIGlzIGV4dHJhY3RlZCBmcm9t
IE1ha2VmaWxlCiMgTk9URS0yOiAkZGViaWFuX3Vwc3RyZWFtX3ZlcnNpb24gaXMgdXNlZCBpbiBk
ZWItcGtnIG9wdGlvbnMKIyBOT1RFLTM6IENvbnZlcnQgJy1yY1gnIGluICR1cHN0cmVhbV92ZXJz
aW9uIHRvICd+cmNYJyAoc2VlICRleHRyYXZlcnNpb24pCiMgRVhBTVBMRS0xOiBkZWJpYW5fdXBz
dHJlYW1fdmVyc2lvbj0iMy4xOS4wfnJjMiIKIyBFWEFNUExFLTI6IGRlYmlhbl91cHN0cmVhbV92
ZXJzaW9uPSIzLjE5LjB+cmMyfm5leHQiCnZlcnNpb249JChhd2sgJy9eVkVSU0lPTiA9IC8ge3By
aW50ICQzfScgTWFrZWZpbGUpCnBhdGNobGV2ZWw9JChhd2sgJy9eUEFUQ0hMRVZFTCA9IC8ge3By
aW50ICQzfScgTWFrZWZpbGUpCnN1YmxldmVsPSQoYXdrICcvXlNVQkxFVkVMID0gLyB7cHJpbnQg
JDN9JyBNYWtlZmlsZSkKZXh0cmF2ZXJzaW9uPSQoYXdrICcvXkVYVFJBVkVSU0lPTiA9IC8ge3By
aW50ICQzfScgTWFrZWZpbGUpCnVwc3RyZWFtX3ZlcnNpb249IiR7dmVyc2lvbn0uJHtwYXRjaGxl
dmVsfS4ke3N1YmxldmVsfSR7ZXh0cmF2ZXJzaW9ufSIKZGViaWFuX3Vwc3RyZWFtX3ZlcnNpb249
JChlY2hvICR1cHN0cmVhbV92ZXJzaW9uIHwgdHIgJy0nICd+JykKZGViaWFuX3Vwc3RyZWFtX3Zl
cnNpb249IiR7ZGViaWFuX3Vwc3RyZWFtX3ZlcnNpb259fm5leHQiCgojIyMgRGViaWFuIHJldmlz
aW9uIHNldHRpbmdzCiMgTk9URS0xOiAkZGViaWFuX3JldmlzaW9uIGlzIHVzZWQgaW4gZGViLXBr
ZyBvcHRpb25zCiMgTk9URS0yOiAkcmV2aXNpb24gaXMgdXNlZCBpbiAkZGViaWFuX3JldmlzaW9u
IGFuZCAkbXlsb2NhbHZlcnNpb24KIyBFWEFNUExFLTE6IGRlYmlhbl9yZXZpc2lvbj0iMX5wcmVj
aXNlK2RpbGVrczEiCiMgRVhBTVBMRS0yOiBkZWJpYW5fcmV2aXNpb249IjIwMTQxMjMxLjF+cHJl
Y2lzZStkaWxla3MxIgpyZXZpc2lvbj0iMSIKdXBsb2FkZXJfcmV2aXNpb249IjEiCmRlYmlhbl9y
ZXZpc2lvbj0iJHtyZXZpc2lvbn1+JHtkaXN0cmlidXRpb259KyR7dXBsb2FkZXJ9JHt1cGxvYWRl
cl9yZXZpc2lvbn0iCmRlYmlhbl9yZXZpc2lvbj0iJHtuZXh0X2RhdGV9LiR7ZGViaWFuX3Jldmlz
aW9ufSIKCiMjIyBNeSBrZXJuZWwtZmVhdHVyZXNldCBzZXR0aW5ncwojIEVYQU1QTEUtMTogVXNl
IG93biAiaW5pemEiIGZlYXR1cmVzZXQKIyBFWEFNUExFLTI6IFRlc3QgYmxvY2stbG9vcC1tcSAo
djMpIGFzICJsb29wbXEiIGZlYXR1cmVzZXQKbXlmZWF0dXJlc2V0PSJsb29wbXEiCgojIyMgTXkg
a2VybmVsLWZsYXZvdXIgc2V0dGluZ3MKIyBFWEFNUExFOiBVc2Ugb3duICJzbWFsbCIga2VybmVs
LWZsYXZvdXIgKGxvY2FsbW9kY29uZmlnLWVkIHBsdXMgc29tZSBkZWJ1Zy1vcHRpb25zIGVuYWJs
ZWQpIApteWtlcm5lbGZsYXZvdXI9InNtYWxsIgoKIyMjIEN1c3RvbWl6ZWQgTE9DQUxWRVJTSU9O
IHNldHRpbmdzCiMgTk9URS0xOiAkbXlsb2NhbHZlcnNpb24gaXMgYXR0YWNoZWQgYXMgc3VmZml4
IHRvICJpbmNsdWRlL2dlbmVyYXRlZC91dHNyZWxlYXNlLmgiIGZpbGUKIyBOT1RFLTI6IFVzYWdl
IG9mIExPQ0FMVkVSU0lPTj0kbXlsb2NhbHZlcnNpb24gc3VwcHJlc3NlcyAiKyIgc3VmZml4CiMg
Tk9URS0zOiBTZWUgYWxzbyAiI2RlZmluZSBVVFNfUkVMRUFTRSIgaW4gdXRzcmVsZWFzZS5oIGZp
bGUuCiMgV0FSTklORzogRG8gTk9UIHVzZSB1bmRlcnNjb3JlICgiXyIpIGluICRteWxvY2FsdmVy
c2lvbiAoc2VlIDxodHRwOi8vYnVncy5kZWJpYW4ub3JnLzIyMjQ2Nz4pLgojIEVSUi1NU0c6IGRw
a2ctZ2VuY29udHJvbDogZXJyb3I6IElsbGVnYWwgcGFja2FnZSBuYW1lIC4uLgojIEVYQU1QTEUt
MTogbXlsb2NhbHZlcnNpb249IjEtaW5pemEtc21hbGwiCiMgRVhBTVBMRS0yOiBteWxvY2FsdmVy
c2lvbj0iMS1pbml6YS14ODZfNjQiICgieDg2XzY0IiBub3QgYWxsb3dlZCwgdXNlICJhbWQ2NCIg
aW5zdGVhZCkKIyBFWEFNUExFLTM6IG15bG9jYWx2ZXJzaW9uPSJuZXh0LTIwMTQxMjMxLjEtaW5p
emEtc21hbGwiCm15bG9jYWx2ZXJzaW9uPSIke3JldmlzaW9ufS0ke215ZmVhdHVyZXNldH0tJHtt
eWtlcm5lbGZsYXZvdXJ9IgpteWxvY2FsdmVyc2lvbj0ibmV4dC0ke25leHRfZGF0ZX0uJHtteWxv
Y2FsdmVyc2lvbn0iCgojIyMgQnVpbGQtbG9nIGZpbGUKS1ZFUj0iJHt1cHN0cmVhbV92ZXJzaW9u
fS0ke215bG9jYWx2ZXJzaW9ufSIKQlVJTERfTE9HX0ZJTEU9ImJ1aWxkLWxvZ18ke0tWRVJ9LnR4
dCIKCiMjIyBtYWtlIG9wdGlvbnMKTUFLRV9PUFRTPSJDQz0ke0NDX0ZPUl9CVUlMRH0gLWoke01B
S0VfSk9CU30gS0JVSUxEX0JVSUxEX1VTRVI9JHtERUJFTUFJTH0gTE9DQUxWRVJTSU9OPS0ke215
bG9jYWx2ZXJzaW9ufSIKCiMjIyBkZWItcGtnIG9wdGlvbnMKIyBFWEFNUExFLTE6IEtERUJfUEtH
VkVSU0lPTj0iMy4xOS4wfnJjMi0xfnByZWNpc2UrZGlsZWtzMSIKIyBFWEFNUExFLTI6IEtERUJf
Q0hBTkdFTE9HX0RJU1Q9InByZWNpc2UiIChzZXQgZGlzdHJpYnV0aW9uIG5hbWUgZXhwbGljaXRs
eSkKIyBFWEFNUExFLTM6IEtERUJfUEtHVkVSU0lPTj0iMy4xOS4wfnJjMn5uZXh0LTIwMTQxMjMx
LjF+cHJlY2lzZStkaWxla3MxIgpERUJfUEtHX09QVFM9IktERUJfUEtHVkVSU0lPTj0ke2RlYmlh
bl91cHN0cmVhbV92ZXJzaW9ufS0ke2RlYmlhbl9yZXZpc2lvbn0iCiMjREVCX1BLR19PUFRTPSIk
REVCX1BLR19PUFRTIEtERUJfQ0hBTkdFTE9HX0RJU1Q9JGRpc3RyaWJ1dGlvbiIKCiMjIyBMaXN0
IHNvbWUgdmVyc2lvbiBhbmQgb3B0aW9uIHNldHRpbmdzCmVjaG8gIkxpbnV4IHVwc3RyZWFtIHZl
cnNpb24gLi4uLiAke0xBVEVTVF9VUFNUUkVBTV9WRVJfVEFHfSIKZWNobyAiTGludXggbmV4dCB2
ZXJzaW9uIC4uLi4uLi4uICR7TEFURVNUX05FWFRfVkVSX1RBR30iCmVjaG8gIkRlYmlhbiB1cHN0
cmVhbSB2ZXJzaW9uIC4uLiAke2RlYmlhbl91cHN0cmVhbV92ZXJzaW9ufSIKZWNobyAiRGViaWFu
IHJldmlzaW9uIC4uLi4uLi4uLi4uICR7ZGViaWFuX3JldmlzaW9ufSIKZWNobyAibWFrZSBvcHRp
b25zIC4uLi4uLi4uLi4uLi4uICR7TUFLRV9PUFRTfSIKZWNobyAiZGVwLXBrZyBvcHRpb25zIC4u
Li4uLi4uLi4uICR7REVCX1BLR19PUFRTfSIKZWNobyAiIgoKIyMjIFJlbW92ZSBhbnkgZXhpc3Rp
bmcgbG9jYWx2ZXJzaW9uKiBmaWxlKHMpIGFzIGN1c3RvbWl6ZWQgTE9DQUxWRVJTSU9OIGlzIHVz
ZWQKIyBFWEFNUExFOiBMaW51eC1uZXh0IHNoaXBzIGEgImxvY2FsdmVyc2lvbi1uZXh0IiBmaWxl
LgpybSAtZiBsb2NhbHZlcnNpb24qCgojIyMgU3RhcnQgYnVpbGQKZWNobyAiIyMjIyMgU3RhcnRp
bmcgTGludXgta2VybmVsIGJ1aWxkIC4uLiIKZmFrZXJvb3QgJHtNQUtFfSAke01BS0VfT1BUU30g
ZGViLXBrZyAke0RFQl9QS0dfT1BUU30gMj4mMSB8IHRlZSAuLi8ke0JVSUxEX0xPR19GSUxFfQpl
Y2hvICIjIyMjIyBGaW5pc2hlZCEiCg==
--047d7bb0394645cd0d050c0af429--
