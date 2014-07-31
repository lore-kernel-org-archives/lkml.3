Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaGaNRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:17:55 -0400
Received: from out1.virusfree.cz ([212.24.139.170]:49925 "EHLO
	out1.virusfree.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaGaNRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:17:53 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2014 09:17:53 EDT
X-VF-Scanner-Mail-From: jh@excello.cz via out1
X-VF-Scanner-Rcpt-To: linux-kernel@vger.kernel.org
X-VF-Scanner: 2.08VF (Clear:RC:1(212.224.105.53):. Processed in 0.040351 secs Process 4093/4075)
DomainKey-Signature: a=rsa-sha1; c=nofws; d=excello.cz; h=message-id
	:date:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type; q=dns; s=default; b=ERRFIiYBSncUffHk7jhFC5id4LtAJ
	8loLKcO5L957882m+zlNHTdv00k3iYq7M9Oa1kdNSQOBkSfPRHadDKegYUr1R+yF
	hfzx4a43wsKvM5llalpdkaCO7KLaiyKW1HRUo35A63rE2KiAhibKLRWAMgk1ezOp
	d/fcKL9RBvi2Wg=
Message-ID: <53DA4074.9030300@excello.cz>
Date: Thu, 31 Jul 2014 15:11:16 +0200
From: Jan Hejl <jh@excello.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sudden kernel panics on AMD Opteron platforms with hardened kernel
References: <53DA3C5C.3040508@excello.cz> <CAFLxGvz5ph_Sk7XmtCMzSCMj-nOPFm8=phoc3Ng_+gyFjTDh7A@mail.gmail.com>
In-Reply-To: <CAFLxGvz5ph_Sk7XmtCMzSCMj-nOPFm8=phoc3Ng_+gyFjTDh7A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060306080200030609090901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060306080200030609090901
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable


Dne 31.7.2014 v 15:04 Richard Weinberger napsal(a):
> On Thu, Jul 31, 2014 at 2:53 PM, Jan Hejl <jh@excello.cz> wrote:
>> Hello,
>>
>> i'm facing sudden kernel panics. Last one happened few minutes ago.
>> Unfortunatelly only output that i've catched is limited thanks to low
>> resolution of console screen. See screenshot attached.
>>
>> Below is output of the ver_linux script.
>>
>> Linux aq 3.14.12-hardened-r2 #1 SMP Tue Jul 22 18:47:50 CEST 2014 x86_=
64 AMD
> Does the problem also happen with a vanilla kernel?
Didn't tried yet.

As I talked to my collegues we found that these bugs are someway random=20
that it may be related to=20
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D61904. Is it possible?
>
>> Opteron(tm) Processor 6376 AuthenticAMD GNU/Linux
>>   Gnu C                  4.7.3
>> Gnu make               3.82
>> binutils               2.23.2
>> util-linux             scripts/ver_linux: line 23: fdformat: command n=
ot
>> found
>> mount                  assert
>> module-init-tools      18
>> e2fsprogs              1.42.10
>> xfsprogs               3.1.10
>> Linux C Library        Dynamic linker (ldd)   2.17
>> Procps                 3.3.9
>> Net-tools              1.60_p20130513023548
>> Kbd                    1.15.5
>> Sh-utils               8.21
>> Modules Loaded
>>
>> Can you please point to me to a right direction where to start with
>> debugging of this panic? It is badly reproducible because it happens
>> randomly.
>>
>> Hope you'll find all info attached.
>>
>> Thanks for any help!
>> Jan
>>
>
>



--------------ms060306080200030609090901
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Elektronicky podpis S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINPzCC
BkIwggUqoAMCAQICEDirAC//rpa3Vv85Wvtd5xswDQYJKoZIhvcNAQEFBQAwgcoxCzAJBgNV
BAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1
c3QgTmV0d29yazE6MDgGA1UECxMxKGMpIDE5OTkgVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0
aG9yaXplZCB1c2Ugb25seTFFMEMGA1UEAxM8VmVyaVNpZ24gQ2xhc3MgMSBQdWJsaWMgUHJp
bWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEczMB4XDTExMDkwMTAwMDAwMFoXDTIx
MDgzMTIzNTk1OVowgaYxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
dGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEeMBwGA1UECxMVUGVyc29u
YSBOb3QgVmFsaWRhdGVkMTcwNQYDVQQDEy5TeW1hbnRlYyBDbGFzcyAxIEluZGl2aWR1YWwg
U3Vic2NyaWJlciBDQSAtIEc0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxuwn
/R1j9DsdisHTHMjIgoa2uEqGkqqBXHLKMA0vnkEiVzAhJZCao/SsKsaIF4ZhchN2LuwDyyeb
jyCAN+DkitpVplAP/LlcI2mJQqG6H6/vDvmkyQrx+DeyxtmSSq5937hEH5u6P4wG/tgjT0hR
I2pghKjuJy9g35byGiqMPI8AzE/L+iCOvDX24fCatgXz/B0/xhR7DtryBeTTgwKmxWlwtKnk
VunbHVz0pjbia7UeKi3cvrvuOgSwMAitX2hsxr0GloiE5+apZC28ODC7iCbDZ2ZmtLR3+cCh
xw5y72bi5bnK4POFdzWY3tQcsP5mceI4y258T0BV65fZqBge7QIDAQABo4ICRDCCAkAwOAYI
KwYBBQUHAQEELDAqMCgGCCsGAQUFBzABhhxodHRwOi8vcGtpLW9jc3AudmVyaXNpZ24uY29t
MBIGA1UdEwEB/wQIMAYBAf8CAQAwbAYDVR0gBGUwYzBhBgtghkgBhvhFAQcXATBSMCYGCCsG
AQUFBwIBFhpodHRwOi8vd3d3LnN5bWF1dGguY29tL2NwczAoBggrBgEFBQcCAjAcGhpodHRw
Oi8vd3d3LnN5bWF1dGguY29tL3JwYTA0BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8vY3JsLnZl
cmlzaWduLmNvbS9wY2ExLWczLmNybDAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0RBCIwIKQeMBwx
GjAYBgNVBAMTEVZlcmlTaWduTVBLSS0yLTk3MB0GA1UdDgQWBBSt+cOTci21uShh5KTXYNXE
Cl4aATCB8QYDVR0jBIHpMIHmoYHQpIHNMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVy
aVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsT
MShjKSAxOTk5IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBD
BgNVBAMTPFZlcmlTaWduIENsYXNzIDEgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBB
dXRob3JpdHkgLSBHM4IRAItbdVaEVIULAM+vOEjOsaQwDQYJKoZIhvcNAQEFBQADggEBANaP
wdqbiPKzbE0fWC+6AVFddMFG6MO4e5/WQPHv/zK6iWvADjRDn6SZ5qTwXUgzYoWFYf4jiCKM
YJsrnGVJlMSiOCRIpVylUEto6WIip5PomSJuPVu7EEIOH0x1RzRWCY/4vYw881y70pZwVHBi
Te/REL6dSCxe7IZrB4LwPeElJygs4BZ2HrP95WKW0oo9Xyuu+1zCE7dlY8s0dkOf1oeZq26t
lcEAP0Yngf813iMOQ9wUXzL5yinvwlIw9ZnduYH4OiUgjYJo8rkhhXRmBOGGORYy8i3WKqjJ
3tkAAk/jGCDFpYFWtpXe04Kt+HslvmR8LqC6cCz4+XXidE0HbYQwggb1MIIF3aADAgECAhAE
lT3Qzv8VewCwlJdEY+ItMA0GCSqGSIb3DQEBBQUAMIGmMQswCQYDVQQGEwJVUzEdMBsGA1UE
ChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdv
cmsxHjAcBgNVBAsTFVBlcnNvbmEgTm90IFZhbGlkYXRlZDE3MDUGA1UEAxMuU3ltYW50ZWMg
Q2xhc3MgMSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0EgLSBHNDAeFw0xNDA3MzEwMDAwMDBa
Fw0xNTA4MDEyMzU5NTlaMIG/MS4wLAYDVQQDDCVQZXJzb25hIE5vdCBWYWxpZGF0ZWQgLSAx
NDA2Nzk5NjU0MDQ2MRwwGgYJKoZIhvcNAQkBFg1qaEBleGNlbGxvLmN6MQ8wDQYDVQQLDAZT
L01JTUUxHjAcBgNVBAsMFVBlcnNvbmEgTm90IFZhbGlkYXRlZDEfMB0GA1UECwwWU3ltYW50
ZWMgVHJ1c3QgTmV0d29yazEdMBsGA1UECgwUU3ltYW50ZWMgQ29ycG9yYXRpb24wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7LZjJJsMZwyIRXuJbru8HLP/FfADg5r/cZ1FR
r0jha7bfpO6SFG2S5kiGKuomWj4107pTqAcKSmYPKRwyv1o7qDMDFhEqDhf4Q/qDTL2ohFdp
UZA6ELviNLZe8zvs9MylYGGzEI7QZX+r+o2Hcr289hTRJ1ymC3mQlNln3nlfRzlRLXBwoWqM
Mq6cAhdtnXr5sv+Qrz81AfwP7DBi5flSMU5Ni1sJWcSrH3rVJ3Qo03pRi0mo5f+jY9eplrG5
JgfCyZ5rlTl+pk2dsrqH1/km3+FilpsUcyHDrrIuZdGvfsY7vipCDRkYO1i0nvkAqXg2s0vm
XSDPiLAW9czL49k/AgMBAAGjggMCMIIC/jAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIF
oDAgBgNVHSUBAf8EFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwHQYDVR0OBBYEFO1MnjgkRFYa
Bqe5hpWGXzi/amBxMBgGA1UdEQQRMA+BDWpoQGV4Y2VsbG8uY3owHwYDVR0jBBgwFoAUrfnD
k3IttbkoYeSk12DVxApeGgEwggErBggrBgEFBQcBAQSCAR0wggEZMIIBFQYIKwYBBQUHMAKG
ggEHbGRhcDovL2RpcmVjdG9yeS52ZXJpc2lnbi5jb20vQ04lMjAlM0QlMjBTeW1hbnRlYyUy
MENsYXNzJTIwMSUyMEluZGl2aWR1YWwlMjBTdWJzY3JpYmVyJTIwQ0ElMjAtJTIwRzQlMkMl
MjBPVSUyMCUzRCUyMFBlcnNvbmElMjBOb3QlMjBWYWxpZGF0ZWQlMkMlMjBPVSUyMCUzRCUy
MFN5bWFudGVjJTIwVHJ1c3QlMjBOZXR3b3JrJTJDJTIwTyUyMCUzRCUyMFN5bWFudGVjJTIw
Q29ycG9yYXRpb24lMkMlMjBDJTIwJTNEJTIwVVM/Y0FDZXJ0aWZpY2F0ZTtiaW5hcnkwXQYD
VR0fBFYwVDBSoFCgToZMaHR0cDovL3BraS1jcmwuc3ltYXV0aC5jb20vY2FfNTYxYzEwMzY5
MGM5N2E2OTI0N2EwZWYwNzFhYzgxYWYvTGF0ZXN0Q1JMLmNybDBsBgNVHSAEZTBjMGEGC2CG
SAGG+EUBBxcBMFIwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cuc3ltYXV0aC5jb20vY3BzMCgG
CCsGAQUFBwICMBwaGmh0dHA6Ly93d3cuc3ltYXV0aC5jb20vcnBhMCsGCmCGSAGG+EUBEAME
HTAbBhJghkgBhvhFARABAgIEAYbHzm8WBTEwOTIyMDkGCmCGSAGG+EUBEAUEKzApAgEAFiRh
SFIwY0hNNkx5OXdhMmt0Y21FdWMzbHRZWFYwYUM1amIyMD0wDQYJKoZIhvcNAQEFBQADggEB
ABWSa56+iTI1lgEgVfIxrNlrKNGGmPhquhqnPOH5iDxV5QteQdAma7kjt9NplIsVtuMd1QmK
jSzipJ2xvdMUmOMMukzETWZqeqTNcCGL7lQsT+11UGAb+69MtZd1FWTVRlx6Hf4j9heyVrh2
Fc3BaCztV8aOXpuNi3JrbV0BO0iRMsMz2qinm0Ta4QZk5BnPPKOryREQyWSPqmYGG0qyfcam
i0OvJTwmVzxqlhFiaTmRMuIFxFRrZHMgg1X73TgI1nxcaSYk3pIAyKSGUrbM3LCV72zO/ivT
EE1WOe0FSVAR2S+RLiOIgf20R9kE5i1io87FeqduDegaEzaysl5GO3sxggRSMIIETgIBATCB
uzCBpjELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYD
VQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMR4wHAYDVQQLExVQZXJzb25hIE5vdCBWYWxp
ZGF0ZWQxNzA1BgNVBAMTLlN5bWFudGVjIENsYXNzIDEgSW5kaXZpZHVhbCBTdWJzY3JpYmVy
IENBIC0gRzQCEASVPdDO/xV7ALCUl0Rj4i0wCQYFKw4DAhoFAKCCAmswGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwNzMxMTMxMTE2WjAjBgkqhkiG9w0B
CQQxFgQUTjMzo5HMB2VNBzKL86xZowaM084wbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQME
ASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBzAYJKwYBBAGCNxAEMYG+MIG7MIGmMQsw
CQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5
bWFudGVjIFRydXN0IE5ldHdvcmsxHjAcBgNVBAsTFVBlcnNvbmEgTm90IFZhbGlkYXRlZDE3
MDUGA1UEAxMuU3ltYW50ZWMgQ2xhc3MgMSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0EgLSBH
NAIQBJU90M7/FXsAsJSXRGPiLTCBzgYLKoZIhvcNAQkQAgsxgb6ggbswgaYxCzAJBgNVBAYT
AlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMg
VHJ1c3QgTmV0d29yazEeMBwGA1UECxMVUGVyc29uYSBOb3QgVmFsaWRhdGVkMTcwNQYDVQQD
Ey5TeW1hbnRlYyBDbGFzcyAxIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQSAtIEc0AhAElT3Q
zv8VewCwlJdEY+ItMA0GCSqGSIb3DQEBAQUABIIBABbqwIWqNfDvszH5FDVui+oQPDO1Bc+a
iAZNn8fxsq5MNvo0kGW2uOXQOiR4iPH3Oh63713n9b+rHpMVZwOgUVCGLzYMTq9+6vefzh+N
sWi/F0RGjit7WQTOueI7ZLGZa4dfuVSfTZOp/v1i2ckPGi+J/3iZUaoDlmZNGs9DeGY65vyd
XlICX0rOVagk9W/LjCKxUufm/GPm8jRRJpuOgUMEUDFbVr0/LZjLdBPg7weQrYlBwzQQUu2i
qqilmVDDmsqHwQce8wDavNW7jIg6vL9Ex46tlf8w4SEKESJOPgs4obPayDJJ1GDG6MIrrhqt
cIELmpvX2wiZNhEoTm5t7kkAAAAAAAA=
--------------ms060306080200030609090901--
